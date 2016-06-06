class WrappageMovementsController < ApplicationController
  before_action :set_wrappage_movement, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @wrappage_movements = WrappageMovement.all
    respond_with(@wrappage_movements)
  end

  def show
    respond_with(@wrappage_movement)
  end

  def new
    @wrappage_movement = WrappageMovement.new
    respond_with(@wrappage_movement)
  end

  def edit
  end

  def create
    @wrappage_movement = WrappageMovement.new(wrappage_movement_params)
    @wrappage_movement.save
    respond_with(@wrappage_movement)
  end

  def update
    @wrappage_movement.update(wrappage_movement_params)
    respond_with(@wrappage_movement)
  end

  def destroy
    @wrappage_movement.destroy
    respond_with(@wrappage_movement)
  end

  def import
    if request.post?
      msg = Message.new
      begin
        file=params[:files][0]
        fd = FileData.new(data: file, oriName: file.original_filename, path: $tmp_file_path, pathName: "#{Time.now.strftime('%Y%m%d%H%M%S%L')}~#{file.original_filename}")
        fd.save
        msg = FileHandler::Excel::WrappageMovementHandler.import(fd, current_user)
      rescue => e
        msg.content = e.message
      end
      render json: msg
    end
  end

  private
    def set_wrappage_movement
      @wrappage_movement = WrappageMovement.find(params[:id])
    end

    def wrappage_movement_params
      params.require(:wrappage_movement).permit(:move_date, :package_type_id, :user_id)
    end
end
