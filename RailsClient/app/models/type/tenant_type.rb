class TenantType<BaseType
  SELF=100
  SUPPLIER=200
  CLIENT=300


  def self.display(v)
    case v
      when SELF
        '本公司'
      when SUPPLIER
        '供应商'
      when CLIENT
        '客户'
    end
  end
end