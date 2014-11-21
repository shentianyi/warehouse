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
    case state
      when INIT
        'Init'
      when WAY
        'On Way'
      when ARRIVED
        'Arrived'
      when CHECKED
        'Checked'
      when REJECTED
        'Rejected'
      else
        'Nil'
    end
  end

  def self.state
    data = []
    self.constants.each do |c|
      v = self.const_get(c.to_s)
      data << [self.display(v),v]
    end
    data
  end
end