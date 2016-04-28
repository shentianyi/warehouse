class BackPartState
  INIT = 100
  ENDING = 200

  def self.display state
    case state
      when INIT
        '新建'
      when ENDING
        '结束'
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
end