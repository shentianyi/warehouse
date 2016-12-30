class DockPointsController < ApplicationController
  before_action :set_dock_point, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @dock_points = DockPoint.all.paginate(:page=> params[:page])
    respond_with(@dock_points)
  end

  def show
    respond_with(@dock_point)
  end

  def new
    @dock_point = DockPoint.new
    respond_with(@dock_point)
  end

  def edit
  end

  def create
    @dock_point = DockPoint.new(dock_point_params)
    @dock_point.save
    respond_with(@dock_point)
  end

  def update
    @dock_point.update(dock_point_params)
    respond_with(@dock_point)
  end

  def destroy
    @dock_point.destroy
    respond_with(@dock_point)
  end

  def import
    if request.post?
      msg = Message.new
      begin
        file=params[:files][0]
        fd = FileData.new(data: file, oriName: file.original_filename, path: $tmp_file_path, pathName: "#{Time.now.strftime('%Y%m%d%H%M%S%L')}~#{file.original_filename}")
        fd.save
        msg = FileHandler::Excel::DockPointHandler.import(fd)
      rescue => e
        msg.content = e.message
      end
      render json: msg
    end
  end

  private
    def set_dock_point
      @dock_point = DockPoint.find(params[:id])
    end

    def dock_point_params
      params.require(:dock_point).permit(:nr, :desc)
    end
end
