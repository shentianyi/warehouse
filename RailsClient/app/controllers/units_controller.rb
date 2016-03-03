class UnitsController < ApplicationController
  before_action :set_unit, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @units = Unit.paginate(:page => params[:page], :per_page => 100)
    respond_with(@units)
  end

  def show
    respond_with(@unit)
  end

  def new
    @unit = Unit.new
    respond_with(@unit)
  end

  def edit
  end

  def create
    @unit = Unit.new(unit_params)
    @unit.save
    respond_with(@unit)
  end

  def update
    @unit.update(unit_params)
    respond_with(@unit)
  end

  def destroy
    @unit.destroy
    respond_with(@unit)
  end

  def import
    if request.post?
      msg = Message.new
      begin
        file=params[:files][0]
        fd = FileData.new(data: file, oriName: file.original_filename, path: $tmp_file_path, path_name: "#{Time.now.strftime('%Y%m%d%H%M%S%L')}~#{file.original_filename}")
        fd.save
        msg = FileHandler::Excel::UnitHandler.import(fd)
      rescue => e
        msg.content = e.message
      end
      render json: msg
    end
  end

  private
    def set_unit
      @unit = Unit.find(params[:id])
    end

    def unit_params
      params.require(:unit).permit(:nr, :name, :short_name, :description)
    end
end
