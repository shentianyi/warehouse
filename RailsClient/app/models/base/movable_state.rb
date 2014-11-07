class MovableState
  INIT = 0
  WAY = 1
  ARRIVED = 2

  # get pre states of a specific state
  def self.pre_states(to)
    case to
      when INIT
        return [INIT]
      when WAY
        return [INIT]
      when ARRIVED
        return [INIT,WAY]
    end
  end
end