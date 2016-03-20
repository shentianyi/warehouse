class MovementsController < ApplicationController
  before_action :set_movement, only: [:show, :edit, :update, :destroy]

# GET /deliveries
  def index
    @movements = Movement.paginate(:page => params[:page])
  end

  def search
    super { |query|
      if part=Part.find_by_nr(params[:movement][:partNr])
        query=query.unscope(where: :partNr).where(partNr: part.id)
      end

      if fromWh=Whouse.find_by_nr(params[:movement][:from_id])
        query=query.unscope(where: :from_id).where(from_id: fromWh.id)
      end
      if position=Position.find_by_nr(params[:movement][:fromPosition])
        query=query.unscope(where: :fromPosition).where(fromPosition: position.id)
      end

      if toWh=Whouse.find_by_nr(params[:movement][:to_id])
        query=query.unscope(where: :to_id).where(to_id: toWh.id)
      end
      if toPosition=Position.find_by_nr(params[:movement][:toPosition])
        query=query.unscope(where: :toPosition).where(toPosition: toPosition.id)
      end

      query
    }
  end

  private
# Use callbacks to share common setup or constraints between actions.
  def set_movement
    @movement = Movement.unscoped.find(params[:id])
  end

  def movement_params
    params.require(:movement).permit(:partNr, :fifo, :from_id, :fromPosition, :to_id, :toPosition, :packageId, :uniqueId, :type_id, :qty, :remarks, :employee)
  end
end
