class ErrorCode
  Errors = [:part]

  class<<self
    Errors.each{|f|
      define_method(f){
        a = f.to_s
        a[0] = a[0].capitalize
        (a+"ErrorCode").constantize
      }
    }
  end

  def self.default
    0
  end
end