class LocationContainerService
  def self.search params
    LocationContainer.where(params).first
  end

  def self.dispatch lc,source,destination,user
    begin
      unless lc.dispatch(source,destination,user.id)
        raise
      end
      lc.children.each do |c|
        dispatch(c,source,destination,user.id)
      end
      lc.save
    rescue
        false
    else
      true
    end
  end

  def self.receive lc,user
    begin
      unless lc.receive(user.id)
        raise
      end
        lc.children.each do |c|
          receive(c,user.id)
        end
        lc.save
    rescue
        false
    else
      true
    end
  end
end