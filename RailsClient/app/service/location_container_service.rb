class LocationContainerService

  # send
  # location container and its children
  def self.send lc
    lc.send
    lc.children.each do |c|
      self.send(c)
    end
  end

  def self.before_send lc
    #check container state
    
    #check movable state

    #check children state
  end
end