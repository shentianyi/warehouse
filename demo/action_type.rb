class ActionType
  BASE = 0
  MOVE = 1

  def self.get_type(type)
    self.const_get(type)
  end
end