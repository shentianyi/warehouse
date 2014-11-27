class DeliveryService

  def self.dispatch(movable,destination,user)
    unless (m = d.get_movable_service.dispatch(movable,destination,user)).result
      return m
    end

    m.descendants.each {|d|
      unless (m = d.get_movable_service.dispatch(d,destination,user)).result
        return m
      end
    }
    return Message.new.set_true
  end

  def self.receive(movable,user)
    unless (m = d.get_movable_service.receive(movable,user)).result
      return m
    end

    m.descendants.each {|d|
      unless (m = d.get_movable_service.receive(d,user)).result
        return m
      end
    }
    return Message.new.set_true
  end

  #兼容以前的接口
  def self.confirm_receive movable,user
    unless (m = d.get_movable_service.check(movable,user)).result
      return m
    end

    #设置forklift的状态
    d.children.each {|c|
      unless (m = c.get_movable_service.check(c,user)).result
        return m
      end
    }
    return Message.new.set_true
  end

  def self.create args, user
    msg=Message.new
    ActiveRecord::Base.transaction do
      delivery=Delivery.new(remark: args[:remark], user_id: user.id, location_id: user.location_id)
      if delivery.save
        lc=delivery.logistics_containers.build(source_location_id: user.location_id, user_id: user.id, remark: args[:remark])
        lc.destinationable=user.location.destination
        lc.des_location_id=user.location.destination.id

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

  def self.search(conditions)
    LogisticsContainer.joins(:delivery).where(conditions)
  end

  def self.import_by_file path
    msg=Message.new
    begin
      ActiveRecord::Base.transaction do
        Sync::Config.skip_muti_callbacks([Container, LogisticsContainer,Record])
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
        delivery=Delivery.new(state: DeliveryState::WAY,
                              user_id: book.cell(2, 1),
                              source_id: book.cell(2, 2),
                              destination_id: book.cell(2, 3),
                              delivery_date: book.cell(2, 4),
                              remark: book.cell(2, 5))
        # generate forklifts
        forklifts={}
        book.default_sheet=book.sheets[1]
        return nil if book.cell(2, 1).nil?

        2.upto(book.last_row) do |row|
          whouse=book.cell(row, 1)
          forklift=Forklift.new(state: ForkliftState::WAY,
                                user_id: delivery.user_id,
                                stocker_id: delivery.user_id,
                                whouse_id: Whouse.find_by_id(whouse).id)
          delivery.forklifts<<forklift
          forklifts[whouse]=forklift
        end
        # generate packages
        book.default_sheet=book.sheets[2]
        return nil if book.cell(2, 1).nil?
        2.upto(book.last_row) do |row|
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
        end

        delivery.save
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
        2.upto(book.last_row) do |row|
          if package=Package.find_by_id(book.cell(row, 1))
            package.update(state: PackageState::RECEIVED, is_dirty: true)
            if  forklift=package.forklift
              forklift.update(state: ForkliftState::RECEIVED, is_dirty: true)
              if delivery= forklift.delivery
                delivery.update(state: DeliveryState::RECEIVED, is_dirty: true)
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
