#ecoding: utf-8

class Message
  attr_accessor :result,:object,:content

  def initialize
    self.result = false
    self.content = ''
  end

  def default
    {:result=>0}
  end

  def set_false msg=nil
    self.result=0
    self.content<<msg if msg
  end

  def set_true msg=nil
    self.result=0
    self.content<<msg if msg
  end


end