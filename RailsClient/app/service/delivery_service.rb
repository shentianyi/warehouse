class DeliveryService
  #=============
  #check add forklift
  #=============
  def self.check_add_forklifts forklift_ids
    Forklift.where(id: forklift_ids).where.not(delivery_id: nil).count > 0
  end


  #=============
  #delete @delivery
  #delete a delivery
  #=============
  def self.delete delivery
    if delivery
      ActiveRecord::Base.transaction do
        delivery.forklifts.each do |f|
          f.remove_from_delivery
        end
        delivery.destroy
      end
    else
      false
    end
  end

  #=============
  #update @args
  #update a delivery
  #=============
  def self.update delivery, args
    if delivery.nil?
      return false
    end
    delivery.update_attributes(args)
  end

  def self.add_forklifts delivery, forklift_ids
    if delivery.nil?
      return false
    end
    ActiveRecord::Base.transaction do
      unless forklift_ids.nil?
        forklift_ids.each do |f_id|
          f = Forklift.find_by_id(f_id)
          if f && f.packages.count > 0
            f.add_to_delivery(delivery.id)
          end
        end
      end
    end
    true
  end

  #=============
  #remove_forklifk @forklift
  #remove a forklift from delivery
  #=============
  def self.remove_forklifk forklift

    if forklift.nil?
      return false
    end

    forklift.remove_from_delivery
  end

  #=============
  #serarch args,all=false
  #search delivery if all is true,return all packages' detail information
  #=============
  def self.search(args, all=false)
    if all
      Delivery.where(args).order(created_at: :desc)
    elsif args[:received_date].empty?
      []
    else
      received_date = Time.parse(args[:received_date])
      Delivery.where(state: args[:state], received_date: (received_date.beginning_of_day..received_date.end_of_day)).all.order(created_at: :desc)
    end
  end

  #=============
  #confirm_received @delivery,@current_user
  #set the delivery state to RECEIVED
  #=============
  def self.confirm_received(delivery, current_user)
    if delivery.nil?
      return false
    end
    ActiveRecord::Base.transaction do
      if delivery.set_state(DeliveryState::RECEIVED)
        delivery.forklifts.each do |f|
          ForkliftService.confirm_received(f)
        end
        #delivery.receiver = current_user
        #delivery.received_date = Time.now
        #delivery.save
        delivery.update({receiver: current_user,received_date:Time.now})
      else
        false
      end
    end
  end

  #=============
  #receive @delivery
  #set state to DESTINATION
  #=============
  def self.receive(delivery)
    if delivery.nil?
      return false
    end

    if (delivery.state == DeliveryState::RECEIVED)
      return true
    end

    ActiveRecord::Base.transaction do
      if !delivery.set_state(DeliveryState::DESTINATION)
        return false
      end
      delivery.forklifts.each do |f|
        ForkliftService.receive(f)
      end
    end
    true
  end

  #=============
  #semd @delivery
  #set state to WAY
  #=============
  def self.send(delivery, current_user)
    if delivery.nil?
      return false
    end

    if delivery.forklifts.count == 0
      return false
    end

    ActiveRecord::Base.transaction do
      delivery.delivery_date = Time.now
      delivery.set_state(DeliveryState::WAY)
      delivery.forklifts.each do |f|
        ForkliftService.send(f)
      end
    end
    true
  end

  #=============
  #set_state @delivery,@state
  #set delivery to a specific state
  #=============
  def self.set_state(delivery, state)
    if delivery.nil?
      return false
    end
    ActiveRecord::Base.transaction do
      if delivery.set_state(state)
        delivery.forklifts.each do |f|
          ForkliftService.set_state(f, state)
        end
      end
    end
  end

  #=============
  #exit? @id
  #=============
  def self.exit? id
    Delivery.includes(forklifts: :packages).find_by_id(id)
  end

  #=============
  #import_by_file
  #=============
  # def self.import_by_file path
  #  msg=Message.new
  #  ActiveRecord::Base.transaction do
  #   Sync::Config.skip_muti_callbacks([Delivery, Forklift, Package, PackagePosition, StateLog])
  #  data=JSON.parse(IO.read(path))
  #  msg.result =true # unless Delivery.find_by_id(data['delivery']['id'])
  # Delivery.create(data['delivery'])
  # Forklift.create(data['forklifts'])
  # Package.create(data['packages'])
  # PackagePosition.create(data['package_positions'].select { |pp| !pp.nil? })
  # StateLog.create(data['state_logs'])
  # end
  # return msg
  # end
  def self.import_by_file path
    msg=Message.new
    begin
      ActiveRecord::Base.transaction do
        Sync::Config.skip_muti_callbacks([Delivery, Forklift, Package, PackagePosition, StateLog])
        data=JSON.parse(IO.read(path))
        msg.result =true # unless Delivery.find_by_id(data['delivery']['id'])
        if dori=Delivery.find_by_id(data['delivery']['id'])
          dtmp=Delivery.new(data['delivery'])
          if dori.updated_at<=dtmp.updated_at
            attr=dori.gen_sync_attr(dtmp)
            dori.update(attr)
          end
        else
          Delivery.create(data['delivery'])
        end
        data['forklifts'].each do |forklift|
          if fori=Forklift.find_by_id(forklift['id'])
            ftmp=Forklift.new(forklift)
            if fori.updated_at<=ftmp.updated_at
              attr=fori.gen_sync_attr(ftmp)
              fori.update(attr)
            end
          else
            Forklift.create(forklift)
          end
        end

        data['packages'].each do |package|
          if pori=Package.find_by_id(package['id'])
            ptmp=Package.new(package)
            if pori.updated_at<=ptmp.updated_at
              attr=pori.gen_sync_attr(ptmp)
              pori.update(attr)
            end
          else
            Package.create(package)
          end
        end

        PackagePosition.create(data['package_positions'].select { |pp| !pp.nil? })
        StateLog.create(data['state_logs'])
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
            package.update(state: PackageState::RECEIVED,is_dirty:true)
            if  forklift=package.forklift
              forklift.update(state: ForkliftState::RECEIVED,is_dirty:true)
              if delivery= forklift.delivery
                delivery.update(state: DeliveryState::RECEIVED,is_dirty:true)
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
