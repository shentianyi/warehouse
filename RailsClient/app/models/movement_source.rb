class MovementSource < ActiveRecord::Base
  belongs_to :movement_list

  def self.save_record(params)
    msg = Message.new()
    msg.result=false

    if part=Part.find_by_nr(params[:partNr])
      params[:partNr]=part.id
    end
    if toWh=Whouse.find_by_nr(params[:toWh])
      params[:toWh]=toWh.id
    end
    if toPosition=Position.find_by_nr(params[:toPosition])
      params[:toPosition]=toPosition.id
    end
    if fromWh=Whouse.find_by_nr(params[:fromWh])
      params[:fromWh]=fromWh.id
    end
    if fromPosition=Position.find_by_nr(params[:fromPosition])
      params[:fromPosition]=fromPosition.id
    end

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
      m=MovementSource.where(toWh: params[:toWh],
                             toPosition: params[:toPosition],
                             fromWh: params[:fromWh],
                             fromPosition: params[:fromPosition],
                             packageId: params[:packageId]).first
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

  def self.processing_count_by_position position
    if position
      MovementSource.joins(:movement_list).where(toPosition: position.id).where("movement_lists.state = ?", MovementListState::PROCESSING).size
    else
      0
    end
  end
end
