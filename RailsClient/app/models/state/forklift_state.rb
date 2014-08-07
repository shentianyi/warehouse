class ForkliftState<BaseState
  PART_RECEIVED=4
  def self.display state
    case state
      when PART_RECEIVED
        '部分接收'
      else
        super
    end
  end

  def self.can_change? old_state,new_state
    case old_state
      when DESTINATION
        [DESTINATION,ORIGINAL,WAY,RECEIVED,PART_RECEIVED].include? new_state
      when PART_RECEIVED
        [DESTINATION].include? new_state
      else
        super old_state,new_state
    end
  end

  def self.before_state? source,target
    case source
      when DESTINATION
        [DESTINATION,WAY,ORIGINAL].include? target
      when PART_RECEIVED
        [WAY,DESTINATION].include? target
      else
        super source,target
    end
  end
end