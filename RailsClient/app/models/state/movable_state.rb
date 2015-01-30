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
        [INIT]
      when WAY
        [INIT,WAY]
      when ARRIVED
        [ARRIVED,WAY]
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
        '备货'
      when WAY
        '在途'
      when ARRIVED
        '到达'
      when CHECKED
        '已接收'
      when REJECTED
        '被拒收'
      else
        '未知'
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

  def self.state_value
    data = []
    self.constants.each do |c|
      v = self.const_get(c.to_s)
      data << v
    end
    data
  end
end

class FMovableState<MovableState
  PART_CHECKED=5

  def self.display(state)
    case state
      when PART_CHECKED
        '部分接收'
      else
        super
    end
  end

  def self.before(state)
    case state
      when PART_CHECKED
        [CHECKED,REJECTED,ARRIVED]
      else
        super
    end
  end
end