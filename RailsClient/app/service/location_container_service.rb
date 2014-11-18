class LocationContainerService
  def self.destroy_by_id(id)
    msg=Message.new
    if lc=LogisticsContainer.exists?(id)
      # lee to rewrite
      if lc.can? 'delete'
        ActiveRecord::Base.transaction do
          lc.children.each do |c|
            c.remove
          end
          lc.destroy
          msg.result = true
        end
      else
        msg.content =BaseMessage::STATE_CANNOT_DESTROY
      end
    else
      msg.content =BaseMessage::NOT_EXISTS
    end
    msg
  end
end