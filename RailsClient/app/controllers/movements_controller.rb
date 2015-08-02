class MovementsController < ApplicationController
  before_action :set_movement, only: [:show, :edit, :update, :destroy]

# GET /deliveries
  def index
    @movements = Movement.paginate(:page => params[:page])
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
