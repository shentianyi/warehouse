class LocationType<BaseType

  INTERNAL=100
  SUPPLIER=200
  CLIENT=300
  TRANSPORT=400
  OTHER=900

  def self.display(v)
    case v
      when INTERNAL
        '内部位置'
      when SUPPLIER
        '供应商位置'
      when CLIENT
        '客户位置'
      when TRANSPORT
        '中转位置'
      else
        '其他'
    end
  end
end