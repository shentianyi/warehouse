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

    unless lc.updateable?
      msg.content = PackageMessage::CannotUpdate
      return msg
    end

    unless Part.exists?(args[:part_id])
      msg.content = PackageMessage::PartNotExit
      return msg
    end

    if msg.result=package.update_attributes(args)
      lc.package=package
      msg.object = lc
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