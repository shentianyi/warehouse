module DatetimeHelper
  def self.ddate ddate
    ddate.localtime.strftime("%Y-%m-%d %H:%M")
  end
end