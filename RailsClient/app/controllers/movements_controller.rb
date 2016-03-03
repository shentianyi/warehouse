class MovementsController < ApplicationController
  before_action :set_movement, only: [:show, :edit, :update, :destroy]

# GET /deliveries
  def index
    @movements = Movement.paginate(:page => params[:page])
  end

  def search
    super { |query|
      unless params[:movement][:from_position_id].blank?
        if from_position = Position.find_by_nr(params[:movement][:from_position_id])
          query = query.unscope(where: :from_position_id).where(from_position_id: from_position.id)
        end
      end

      unless params[:movement][:to_position_id].blank?
        if to_position = Position.find_by_nr(params[:movement][:to_position_id])
          query = query.unscope(where: :to_position_id).where(to_position_id: to_position.id)
        end
      end

      unless params[:movement][:part_id].blank?
        if part = Part.find_by_nr(params[:movement][:part_id])
          query = query.unscope(where: :part_id).where(part_id: part.id)
        end
      end

      unless params[:movement][:user_id].blank?
        if user = User.find_by_nr(params[:movement][:user_id])
          query = query.unscope(where: :user_id).where(user_id: user.id)
        end
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
