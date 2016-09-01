class StorageOperationRecord < ActiveRecord::Base
  belongs_to :move_type

  def self.save_record(params, type)
    record = {
        toWh: params[:toWh],
        toPosition: params[:toPosition],
        type_id: MoveType.find_by!(typeId: type).id,
        employee_id: (params[:employee_id].present? ? params[:employee_id] : (params[:user].present? ? params[:user].id : nil)),
        remarks: (params[:remarks] if params[:remarks].present?),
        fromWh: (params[:fromWh] if params[:fromWh].present?),
        fromPosition: (params[:fromPosition] if params[:fromPosition].present?),
        fifo: (params[:fifo] if params[:fifo].present?),
        partNr: (params[:partNr] if params[:partNr].present?),
        packageId: (params[:packageId] if params[:packageId].present?),
        qty: (params[:qty] if params[:qty].present?)
    }

    puts record
    StorageOperationRecord.create(record)
  end


  def self.to_xlsx records
    p = Axlsx::Package.new

    wb = p.workbook
    wb.add_worksheet(:name => "sheet1") do |sheet|
      sheet.add_row ["序号", "零件号", "唯一码", "源仓库", "源库位", "目的仓库", "目的库位", "数量", "FIFO", "类型", "备注", "员工号", "创建时间"]
      records.each_with_index { |record, index|



        sheet.add_row [
                          index+1,
                          record.partNr,
                          record.packageId,
                          record.fromWh,
                          record.fromPosition,
                          record.toWh,
                          record.toPosition,

                          record.qty,
                          record.fifo,
                          record.move_type.blank? ? '' : record.move_type.typeId,
                          record.remarks,
                          record.employee_id,
                          record.created_at.present? ? record.created_at.localtime.strftime("%Y-%m-%d %H:%M") : ''
                      ]
      }
    end
    p.to_stream.read
  end
end
