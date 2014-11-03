class CZBase
  def to_json
    kv = {}
    self.instance_variables.each{|k|
      kv[k] = self.instance_variable_get(k)
    }
    kv
  end
end