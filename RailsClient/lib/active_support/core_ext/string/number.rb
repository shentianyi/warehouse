#encoding: utf-8
class String
  def is_number?
    true if Float(self) rescue false
  end

  def new_line
    tmp=self
    left=tmp.slice!(0,12)
    left+" "+tmp
  end
end
