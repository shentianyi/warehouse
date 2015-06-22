module ScrapListsHelper
  def self.gen_title start_t,end_t,sub_title=nil
    "#{Time.parse(start_t).strftime("%Y-%m-%d")}~#{Time.parse(end_t).strftime("%Y-%m-%d")} #{sub_title}报表"
  end
end
