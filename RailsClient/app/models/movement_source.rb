class MovementSource < ActiveRecord::Base
  belongs_to :movement_list
  belongs_to :part, class_name: 'Part', foreign_key: :partNr

  def self.save_record(params)
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
        remarks: params[:remarks]
    }

    m=nil
    if params[:packageId].present?
      m=MovementSource.joins(:movement_list).where(toWh: params[:toWh],
                                                  toPosition: params[:toPosition],
                                                  fromWh: params[:fromWh],
                                                  fromPosition: params[:fromPosition],
                                                  packageId: params[:packageId],
                                                  movement_lists: {state: MovementListState::PROCESSING}).first
    end
    if m.blank?
      msg.result=true
      MovementSource.create(record)
    else
      msg.content = "该移库项已经存在于移库单：#{m.movement_list_id} 中！"
    end
    puts record

    msg
  end
end
