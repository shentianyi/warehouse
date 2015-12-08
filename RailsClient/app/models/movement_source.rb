class MovementSource < ActiveRecord::Base
  belongs_to :movement_list

  def self.save_record(params)
    record = {
        toWh: params[:toWh],
        toPosition: params[:toPosition],
        fromWh: params[:fromWh],
        fromPosition: params[:fromPosition],
        packageId: params[:packageId],
        partNr: params[:partNr],
        movement_list_id: params[:movement_list_id],
        qty: params[:qty]
    }
    puts record
    MovementSource.create(record)
  end
end
