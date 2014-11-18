class PackageService

  #=============
  #create @args,@current_user=nil
  #=============
  def self.create args, user
    msg = Message.new
    unless Package.id_valid? args[:id]
      msg.content = PackageMessage::IdNotValid
      return msg
    end

    #part_id
    unless Part.exists?(args[:part_id])
      #err_code 10001
      msg.content = PackageMessage::PartNotExit
      return msg
    end

    #create
    ActiveRecord::Base.transaction do
      p = Package.new(args)
      p.user_id=user.id
      p.location_id=user.location_id

      if p.save
        lc=p.logistics_containers.build(source_location_id: p.location_id, user_id: p.user_id)
        lc.save
        lc.container=p
        msg.result = true
        msg.object = lc
      else
        msg.content = p.errors.full_messages
      end
    end
    return msg
  end

#=============
#delete @package
#=============
  def self.delete id
    msg = Message.new(content: [])
    msg.result = false
    package = exits? id
    if package.nil?
      msg.content = PackageMessage::NotExit
      return msg
    end

    unless PackageState.can_delete?(package.state)
      msg.content = PackageMessage::DeleteError
      return msg
    end

    ActiveRecord::Base.transaction do
      package.remove_from_forklift
      package.destroy
      msg.result = true
      return msg
    end
  end

#=============
#update @package
#=============
  def self.update args
    msg = Message.new
    msg.result = false
    package = PackageService.exits?(args[:id])
    if package.nil?
      msg.content = PackageMessage::NotExit
      return msg
    end

    unless PackageState.can_update?(package.state)
      msg.content = PackageMessage::CannotUpdate
      return msg
    end

    unless Part.exists?(args[:part_id])
      msg.content = PackageMessage::PartNotExit
      return msg
    end


    need_set_position = false
    if args[:part_id] && package.part_id != args[:part_id]
      need_set_position = true
    end

    #if part_id changed,reset position
    ActiveRecord::Base.transaction do
      msg.result = package.update_attributes(args)
      if need_set_position
        package.set_position
      end

      if msg.result
        msg.object = package
      end
    end
    return msg
  end

#=============
#search @args
#=============
  def self.search(args)
    Package.where(args).all.order(created_at: :desc)
  end
end