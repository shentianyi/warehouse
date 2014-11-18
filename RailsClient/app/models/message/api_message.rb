require 'base_class'

class ApiMessage < CZ::BaseClass
  attr_accessor :result,:content

  def default
    {result:1}
  end

  def set_true(msg=nil)
    self.result = 1
    self.content = msg if msg
    self
  end

  def set_false(msg=nil)
    self.result = 0
    self.content = msg if msg
    self
  end
end