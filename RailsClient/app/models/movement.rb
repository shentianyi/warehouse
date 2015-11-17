class Movement < ActiveRecord::Base
  belongs_to :type, class_name: 'MoveType'
  belongs_to :to, class_name: 'Whouse'
  belongs_to :from, class_name: 'Whouse'
  belongs_to :movement_list

  def self.generate_report_data(date_start, date_end)
    Movement.find_by_sql("select src_qty,dse_qty,partNr from (select SUM(qty) as src_qty,partNr from movements where created_at between '#{Time.parse(date_start).utc.to_s}' and '#{Time.parse(date_end).utc.to_s}' GROUP BY partNr)a join (select sum(quantity) as dse_qty,part_id from scrap_list_items where time between '#{Time.parse(date_start).utc.to_s}' and '#{Time.parse(date_end).utc.to_s}' group by part_id)b on a.partNr=b.part_id ")
  end

  def self.to_xlsx movements
    p = Axlsx::Package.new
    wb = p.workbook

    list = movements
    wb.add_worksheet(:name => "sheet1") do |sheet|
      sheet.add_row ["序号", "零件号", "包装号", "唯一码", "移动量", "类型", "FIFO", "创建时间", "源仓库号", "源库位号", "目的仓库号", "目的库位号", "员工号", "备注"]
      list.each_with_index { |movement, index|
        if movement.id
          sheet.add_row [
                            index+1,
                            movement.partNr,
                            movement.packageId,
                            movement.uniqueId,
                            movement.qty,
                            MoveType.find(movement.type_id).typeId,
                            movement.fifo.present? ? movement.fifo.localtime.strftime("%Y-%m-%d %H:%M") : '',
                            movement.created_at.present? ? movement.created_at.localtime.strftime("%Y-%m-%d %H:%M") : '',
                            movement.from_id,
                            movement.fromPosition,
                            movement.to_id,
                            movement.toPosition,
                            movement.employee_id,
                            movement.remarks
                        ]
        end
      }
    end
    p.to_stream.read
  end

  def self.save_invalid_record params
    move_data = {
                    to_id: params[:toWh],
                    toPosition: params[:toPosition],
                    type_id: MoveType.find_by!(typeId: 'MOVE').id,
                    employee_id: (params[:employee_id] if params[:employee_id].present?),
                    remarks: (params[:remarks] if params[:remarks].present?),
                    movement_list_id: (params[:movement_list_id] if params[:movement_list_id].present?),
                    from_id: params[:fromWh],
                    fromPosition: params[:fromPosition],
                    fifo: (params[:fifo] if params[:fifo].present?),
                    partNr: (params[:partNr] if params[:partNr].present?)
                }
    Movement.create!(move_data)
  end

end