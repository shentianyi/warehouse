class Movement < ActiveRecord::Base
  belongs_to :type, class_name: 'MoveType'
  belongs_to :to, class_name: 'Whouse'
  belongs_to :from, class_name: 'Whouse'


  def self.generate_report_data(date_start, date_end)
    Movement.find_by_sql("select src_qty,dse_qty,partNr from (select SUM(qty) as src_qty,partNr from movements where created_at between '#{Time.parse(date_start).utc.to_s}' and '#{Time.parse(date_end).utc.to_s}' GROUP BY partNr)a join (select sum(quantity) as dse_qty,part_id from scrap_list_items where time between '#{Time.parse(date_start).utc.to_s}' and '#{Time.parse(date_end).utc.to_s}' group by part_id)b on a.partNr=b.part_id ")
  end

end
