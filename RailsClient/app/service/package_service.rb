class PackageService
  #=============
  #dispatch
  #=============
  def self.dispatch lc, destination, user
    unless (m = lc.get_movable_service.dispatch(lc, destination, user)).result
      return m
    end

    return Message.new.set_true
  end

  def self.receive lc, user
    unless (m = lc.get_movable_service.receive(lc, user)).result
      return m
    end

    return Message.new.set_true
  end

  #=============
  #search packages
  #=============
  # def self.search condition
  #   if condition && condition['records.impl_time']
  #     LogisticsContainer.joins(:package).joins(:records).where(condition)
  #   else
  #     LogisticsContainer.joins(:package).where(condition)
  #   end.distinct
  # end

  def self.search(condition, controlled=false, location=nil)
    # if condition && condition['records.impl_time']
    #   LogisticsContainer.joins(:forklift).joins(:records).where(condition)
    # else
    #   LogisticsContainer.joins(:forklift).where(condition)
    # end.distinct

    q= if condition && condition['records.impl_time']
         LogisticsContainer.joins(:package).joins(:records).where(condition)
       else
         LogisticsContainer.joins(:package).where(condition)
       end

    if controlled && location
      q=q.where('des_location_id=? or source_location_id=?', location.id, location.id)
    end
    q.distinct
  end

  #=============
  #where wrapper
  #=============
  def self.where condition
    LogisticsContainer.joins(:package).where(condition)
  end

  #=============
  #create @args,@current_user=nil
  #=============
  def self.create args, user
    puts "#{args}"
    msg = Message.new
    unless Package.id_valid? args[:id]
      msg.content = PackageMessage::IdNotValid
      return msg
    end

    #part_id
    unless part=Part.exists?(args[:part_id])
      #err_code 10001
      msg.content = PackageMessage::PartNotExit
      return msg
    else
      args[:part_id]=part.id
    end

    #create
    ActiveRecord::Base.transaction do
      if args[:id].nil?
        msg.content = '唯一码为空'
        return msg
      end
      p = Package.new(args)
      p.user_id=user.id
      p.location_id=user.location_id

      if p.save
        lc=p.logistics_containers.build(source_location_id: p.location_id, user_id: p.user_id)
        lc.save
        lc.package=p
        msg.result = true
        msg.object = lc
      else
        msg.content = p.errors.full_messages
      end
    end
    return msg
  end


  #=============
  #update @package
  #=============
  def self.update args
    msg = Message.new
    unless lc= LogisticsContainer.exists?(args[:id])
      msg.content = PackageMessage::NotExit
      return msg
    end
    package=lc.package

    unless lc.can_update?
      msg.content = PackageMessage::CannotUpdate
      return msg
    end

    unless Part.exists?(args[:part_id])
      msg.content = PackageMessage::PartNotExit
      return msg
    end

    #
    args[:id] = lc.container_id

    if msg.result=package.update_attributes(args)
      lc.package=package
      msg.object = lc
    end
    return msg
  end

  def self.get_bind_packages_by_location(location_id, user_id=nil)
    query=Package.joins(:logistics_containers).where(location_containers: {source_location_id: location_id, ancestry: nil})
    query=query.where(location_containers: {user_id: user_id}) if user_id
    query.select('containers.*,location_containers.*')
  end

  def self.check_validate_for_send(id, user)
    # CHECK_PACKAGE_IN_STOCK_FOR_DELIVERY
  end

  # ,ware_house_id: user.location.whouse_ids
  def self.enter_stock user, lc, warehouse, position, fifo, raise_error=true
    if package=lc.package

      # 是否是发送给用户地点的?
      if lc.destinationable==user.location
        # 是,则必须接收了以后才能入库
        if lc.state==MovableState::CHECKED
          if storage=NStorage.where(packageId: package.id).first
            if user.location.whouse_ids.include?(storage.ware_house_id) #storage #position==storage.position
              raise '唯一码已入库，不可重复操作'
            else
              # 移库
              WhouseService.new.move({
                                         partNr: package.part_id,
                                         qty: package.quantity,
                                         packageId: package.id,
                                         fromWh: storage.ware_house_id,
                                         toWh: warehouse.id,
                                         toPosition: position.id,
                                         fifo: fifo,
                                         user: user
                                     })
            end
          else
            # 直接入库
            WhouseService.new.enter_stock({
                                              partNr: package.part_id,
                                              qty: package.quantity,
                                              fifo: fifo,
                                              packageId: package.id,
                                              toWh: warehouse.id,
                                              toPosition: position.id,
                                              user: user
                                          })
          end
        else
          raise '唯一码未被接收，不可入库' if raise_error
        end
      else
        # 不是,是否被用户发运了?
        if lc.source_location==user.location
          raise '唯一码已发运，不可入库' if raise_error
        else
          raise '唯一码不可入库, 请联系管理员' if raise_error
        end
      end


      # if storage=NStorage.where(packageId: package.id).first
      #   if user.location.whouse_ids.include?(storage.ware_house_id) #storage #position==storage.position
      #     raise '唯一码已入库，不可重复操作'
      #   end
      # else
      #   # WhouseService.new.enter_stock({
      #   #                                   partNr: package.part_id,
      #   #                                   qty: package.quantity,
      #   #                                   fifo: fifo,
      #   #                                   packageId: package.id,
      #   #                                   toWh: warehouse.id,
      #   #                                   toPosition: position.id,
      #   #                                   user: user
      #   #                               })
      # end


      # if storage
      #   current_location= storage.whouse.location
      # else
      #   current_location=lc.source_location
      # end
      # user_location=user.location
      #
      # if current_location==user.location
      #   if lc.state==MovableState::CHECKED
      #     if storage
      #       WhouseService.new.move({
      #                                  partNr: package.part_id,
      #                                  qty: package.quantity,
      #                                  packageId: package.id,
      #                                  fromWh: storage.ware_house_id,
      #                                  toWh: warehouse.id,
      #                                  toPosition: position.id,
      #                                  fifo: fifo,
      #                                  user: user
      #                              })
      #     else
      #       WhouseService.new.enter_stock({
      #                                         partNr: package.part_id,
      #                                         qty: package.quantity,
      #                                         fifo: fifo,
      #                                         packageId: package.id,
      #                                         toWh: warehouse.id,
      #                                         toPosition: position.id,
      #                                         user: user
      #                                     })
      #     end
      #   elsif lc.state==MovableState::WAY
      #     raise '唯一码已在发运途中，不可入库' if raise_error
      #   else
      #     raise '唯一码已发运，不可入库' if raise_error
      #   end
      # else
      #   destination_location=lc.destinationable
      #   if destination_location==user_location
      #     raise '唯一码未被接收，不可入库' if raise_error
      #   else
      #     raise '唯一码不可入库, 请联系管理员' if raise_error
      #   end
      # end


      return true
    else
      raise "唯一码:#{params[:container_id]}不存在"
    end
    false
  end
end