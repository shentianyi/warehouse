class PartErrorCode
  Errors={:not_exist => 10000}

  class << self
    Errors.each{|k,v|
      define_method(k){
        v
      }
    }
  end
end