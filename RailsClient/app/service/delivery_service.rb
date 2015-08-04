class DeliveryService

  def self.dispatch(movable, destination, user)
    if movable.descendants.count == 0
      return Message.new.set_false("无法发运空运单")
    end

    ActiveRecord::Base.transaction do
      unless (m = movable.get_movable_service.dispatch(movable, destination, user)).result
        return m
      end

      movable.descendants.each { |d|
        unless (m = d.get_movable_service.dispatch(d, destination, user)).result
          return m
        end
      }

      return Message.new.set_true
    end
  end

  def self.receive(movable, user)
    ActiveRecord::Base.transaction do
      unless (m = movable.get_movable_service.receive(movable, user)).result
        return m
      end

      movable.descendants.each { |d|
        unless (m = d.get_movable_service.receive(d, user)).result
          return m
        end
      }
      return Message.new.set_true
    end
  end

  #兼容以前的接口
  def self.confirm_receive movable, user
    ActiveRecord::Base.transaction do
      unless (m = movable.get_movable_service.check(movable, user)).result
        puts '--------------------------'
        puts m.to_json
        return m
      end

      #设置forklift的状态
      movable.children.each { |c|
        unless (m = ForkliftService.confirm_receive(c,user)).result
          return m
        end
      }
      return Message.new.set_true
    end
  end

  def self.create args, user
    msg=Message.new
    ActiveRecord::Base.transaction do
      delivery=Delivery.new(remark: args[:remark], user_id: user.id, location_id: user.location_id)
      if delivery.save
        lc=delivery.logistics_containers.build(source_location_id: user.location_id, user_id: user.id, remark: args[:remark])
        # lc.destinationable=user.location.destination
        # lc.des_location_id=user.location.destination.id

        lc.save
        msg.result=true
        msg.object = lc
      else
        msg.content = delivery.errors.full_messages
      end
    end
    msg
  end

  def self.get_list(conditions)
    LogisticsContainer.joins(:delivery).where(conditions).order(created_at: :desc)
  end

  def self.search(condition)
    if condition && condition['records.impl_time']
      LogisticsContainer.joins(:delivery).joins(:records).where(condition)
    else
      LogisticsContainer.joins(:delivery).where(condition)
    end
  end

  def self.import_by_file path
    msg=Message.new
    begin
      ActiveRecord::Base.transaction do
        Sync::Config.skip_muti_callbacks([Container, LogisticsContainer, Record])
        data=JSON.parse(IO.read(path))

        msg.result =true
        [Container, LogisticsContainer, Record].each do |m|
          data[m.name.tableize].each do |c|
            citmp=m.new(c)
            if ci=m.find_by_id(c['id'])
              if ci.updated_at<=citmp.updated_at
                attr=ci.gen_sync_attr(citmp)
                ci.update(attr)
              end
            else
              citmp.save
            end
          end
        end
      end
      msg.result=true
      msg.content='处理成功'
    rescue => e
      msg.result =false
      msg.content=e.message
    end
    return msg
  end

  def self.send_by_excel file
    msg=Message.new
    begin
      ActiveRecord::Base.transaction do
        book=Roo::Excelx.new file
        book.default_sheet=book.sheets.first
        return nil if book.cell(2, 1).nil?
        # generate delivery
        user = User.find_by_id(book.cell(2, 1))

        unless user
          raise 'User not found!'
        end
        # generate delivery container
        source = Location.find_by_id(book.cell(2, 2))

        unless source
          raise 'Destination not found!'
        end

        delivery = Delivery.create({
                                       remark: book.cell(2, 5),
                                       user_id: user.id,
                                       location_id: source.id
                                   })

        # generate delivery location_container
        destination = Location.find_by_id(book.cell(2, 3))

        unless destination
          raise 'Destination not found!'
        end
        dlc = delivery.logistic_containers.build(source_location_id: source.id, des_location_id: destination.id, user_id: user.id, remark: book.cell(2, 5), state: MovableState::WAY)
        dlc.destinationable = destination
        dlc.save
        # send dlc,create record for dlc
        impl_time = Time.parse(book.cell(2, 4))
        Record.create({recordable: dlc, destiationable: dlc.destinationable, impl_id: user.id, impl_user_type: ImplUserType::SENDER, impl_action: 'dispatch', impl_time: impl_time})
        # generate forklifts containers
        forklifts={}
        book.default_sheet=book.sheets[1]
        return nil if book.cell(2, 1).nil?

        2.upto(book.last_row) do |row|
          whouse= Whouse.find_by_id(book.cell(row, 1))
          unless whouse
            raise 'Warehouse not found!'
          end
=begin
          forklift=Forklift.new(state: ForkliftState::WAY,
                                user_id: delivery.user_id,
                                stocker_id: delivery.user_id,
                                whouse_id: Whouse.find_by_id(whouse).id)
          delivery.forklifts<<forklift
=end
          forklift = Forklift.create({
                                         user_id: user.id,
                                         location_id: source.id
                                     })
          #create forklift lc
          flc = forklift.logistics_containers.build({source_location_id: source.id, des_location_id: destination.id, user_id: user.id, state: MovableState::WAY})
          flc.destinationable = whouse
          flc.save
          #impl_time = Time.parse(book.cell(2, 4))
          Record.create({recordable: flc, destiationable: flc.destinationable, impl_id: user.id, impl_user_type: ImplUserType::SENDER, impl_action: 'dispatch', impl_time: impl_time})

          dlc.add(flc)

          forklifts[whouse.id]=flc
        end
        # generate packages
        book.default_sheet=book.sheets[2]
        return nil if book.cell(2, 1).nil?
        2.upto(book.last_row) do |row|
          if plc = LogisticsContainer.find_latest_by_container_id(book.cell(row, 2))
            #if found and can copy
            forklifts[book.cell(row, 1)].add(plc)
          else
            #create container
            package = Package.create({
                                         user_id: user.id,
                                         location_id: source.id
                                     })
            #create lc
            #*王松修改了package check_in_time之后，需要重新写
            plc = package.logistics_containers.build({
                                                         source_location_id: source.id,
                                                         des_location_id: destination.id,
                                                         user_id: user.id,
                                                         state: MovableState::WAY,
                                                         part_id: bool.cell(row, 3).sub(/P/, ''),
                                                         quantity: bool.cell(row, 4).sub(/Q/, ''),
                                                         check_in_time: book.cell(row, 5).sub(/W\s*/, '')
                                                     })
            plc.destinationable = PartService.get_position_by_whouse_id(op.part_id, flc.destinationable_id)
            plc.save
            #impl_time = Time.parse(book.cell(2, 4))
            Record.create({recordable: plc, destiationable: plc.destinationable, impl_id: user.id, impl_user_type: ImplUserType::SENDER, impl_action: 'dispatch', impl_time: impl_time})
            forklifts[book.cell(row, 1)].add(plc)
          end

=begin
          if package=Package.find_by_id(book.cell(row, 2))
            forklifts[book.cell(row, 1)].packages<<package
          else
            forklifts[book.cell(row, 1)].packages<<Package.new(id: book.cell(row, 2),
                                                               location_id: delivery.source_id,
                                                               user_id: delivery.user_id,
                                                               part_id: book.cell(row, 3).sub(/P/, ''),
                                                               quantity: book.cell(row, 4).sub(/Q/, ''),
                                                               quantity_str: book.cell(row, 4).sub(/Q/, ''),
                                                               check_in_time: book.cell(row, 5).sub(/W\s*/, ''),
                                                               state: PackageState::WAY
            )
          end
=end
        end

        #delivery.save
=begin
        forklifts.values.each do |forklift|
          forklift.update(sum_packages: forklift.packages.count)
        end
=end
        msg.content ='处理成功'
        msg.result =true
      end
    rescue => e
      msg.result=false
      msg.content = e.message
    end
    return msg
  end

  def self.receive_by_excel file
    msg=Message.new
    begin
      ActiveRecord::Base.transaction do
        book=Roo::Excelx.new file
        book.default_sheet=book.sheets.first
        return nil if book.cell(2, 1).nil?

        default_receiver = User.where({role_id: Role.sender}).first

        2.upto(book.last_row) do |row|
          if plc = LogisticsContainer.find_latest_by_container_id(book.cell(2, 1))
            plc.get_movable_service.receive(plc, default_receiver)

            if  flc = plc.parent
              flc.get_movable_service.receive(flc, default_receiver)

              if dlc = flc.parent
                dlc.get_movable_service.receive(dlc, default_receiver)
              end
            end
          end

        end
      end
      msg.result =true
      msg.content = '处理成功'
    rescue => e
      msg.result=false
      msg.content = e.message
    end
    return msg
  end
end
