class ForkliftService
  def self.create args, user
    msg = Message.new
    unless whouse=Whouse.find_by_id(args[:destinationable_id])
      msg.content = ForkliftMessage::WarehouseNotExit
      return msg
    end

    ActiveRecord::Base.transaction do
      forklift = Forklift.new(user_id: user.id, location_id: user.location_id)
      if forklift.save
        lc=forklift.logistics_containers.build(source_location_id: user.location_id, user_id: user.id)
        lc.destinationable=whouse
        lc.save

        msg.result=true
        msg.object = lc
      else
        msg.content = forklift.errors.full_messages
      end
    end
    return msg
  end


  def self.search(conditions)
    LogisticsContainer.joins(:forklift).where(conditions)
  end
end
