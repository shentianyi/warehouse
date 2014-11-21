class MovableState
  INIT = 0
  WAY = 1
  ARRIVED = 2
  CHECKED = 3
  REJECTED = 4

  # get pre states of a specific state
  def self.before(state)
    case state
      when INIT
        []
      when WAY
        [INIT]
      when ARRIVED
        [WAY]
      when CHECKED
        [ARRIVED,REJECTED]
      when REJECTED
        [ARRIVED,CHECKED]
      else
        []
    end
  end

  def self.base(state)
    case state
      when INIT
        CZ::State::INIT
      else
        CZ::State::LOCK
    end
  end

  def self.display(state)
    'OK'
  end
end