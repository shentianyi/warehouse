class InventoryListState
  BEGINNING = 100
  PROCESSING = 200
  ENDING =300
  
  def self.display state
    case state
      when BEGINNING
        '新建'
      when PROCESSING
        '进行中'
      when ENDING
        '结束'
      else
        '未知状态'
    end
  end
end