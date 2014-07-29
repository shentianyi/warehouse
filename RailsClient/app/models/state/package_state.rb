class PackageState<BaseState
  def self.display state
    super
  end

  def self.before_state? source,target
    case source
      when ORIGINAL
        false
      when WAY
        [ORIGINAL].include? target
      when DESTINATION
        [DESTINATION,WAY,ORIGINAL].include? target
      when RECEIVED
        [WAY,DESTINATION].include? target
      else
        super
    end
  end
end