class MovementSource < ActiveRecord::Base
  self.inheritance_column = nil
  belongs_to :movement_list

  def self.save_record(params, type)
    msg = Message.new()
    msg.result=false

    record = {
        toWh: params[:toWh],
        toPosition: params[:toPosition],
        fromWh: params[:fromWh],
        fromPosition: params[:fromPosition],
        packageId: params[:packageId],
        partNr: params[:partNr],
        movement_list_id: params[:movement_list_id],
        qty: params[:qty],
        employee_id: params[:user].blank? ? '' : params[:user].id,
        fifo: params[:fifo],
        remarks: params[:remarks],
        type: type
    }

    m=nil
    if params[:packageId].present?
      m=MovementSource.where(
          toWh: params[:toWh],
          toPosition: params[:toPosition],
          fromWh: params[:fromWh],
          fromPosition: params[:fromPosition],
          packageId: params[:packageId],
          type: type
      ).first
    end
    if m.blank?
      msg.result=true
      MovementSource.create(record)
    else
      if type=='MOVE'
        msg.content = "该移库项已经存在于移库单：#{m.movement_list_id} 中！"
      else
        msg.content = "该入库项已经存在于入库单：#{m.movement_list_id} 中！"
      end
    end
    puts record

    msg
  end
end
