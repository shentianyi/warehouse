class StorageOperationRecord < ActiveRecord::Base

  def self.save_record(params, type)
    record = {
        toWh: params[:toWh],
        toPosition: params[:toPosition],
        type_id: MoveType.find_by!(typeId: type).id,
        employee_id: (params[:employee_id].present? ? params[:employee_id] : (params[:user].present? ? params[:user].id : nil)),
        remarks: (params[:remarks] if params[:remarks].present?),
        fromWh: (params[:fromWh] if params[:fromWh].present?),
        fromPosition: (params[:fromPosition] if params[:fromPosition].present?),
        partNr: (params[:partNr] if params[:partNr].present?),
        qty: (params[:qty] if params[:qty].present?)
    }

    puts record
    StorageOperationRecord.create(record)
  end
end
