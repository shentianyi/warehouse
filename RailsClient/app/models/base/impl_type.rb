class ImplType
  MANUAL=0   #手动
  SCANNER=1  #扫描

  def self.display type
    case type
      when MANUAL
        '手动'
      when SCANNER
        '扫描'
      else
        '未知'
    end
  end

  def self.list

  end
end