class PrintLabelEnum
  DATA='DATA'
  CONFIG='CONFIG'
  TEMPLATE='TEMPLATE'

  @@enums=nil

  def self.display(type)
    case type
      when DATA
        'DATA'
      when CONFIG
        'CONFIG'
      when TEMPLATE
        'TEMPLATE'
      else
        ''
    end
  end

  def self.enums
    return @@enums if @@enums
     @@enums=[]
    self.constants.each do |c|
      v=self.const_get(c.to_s)
      @@enums<< SelectOption.new({value: v, display: self.display(v)})
    end
    return @@enums
  end
end