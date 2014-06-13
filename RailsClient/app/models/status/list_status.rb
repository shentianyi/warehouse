class ListStatus
  #status for delivery, forklift, forklift_item
  PREPARING = 0
  FINISH_PREPARING = 1
  WAY = 2
  DESTINATION = 3
  ACCEPTED = 4
  REJECTED = 5

  def self.display status
    case status
      when PREPARING
        '准备中'
      when FINISH_PREPARING
        '准备完成'
      when WAY
        '在途'
      when DESTINATION
        '到达'
      when ACCEPTED
        '接受'
      when REJECTED
        '拒收'
      else
        '未知状态'
    end
  end
end