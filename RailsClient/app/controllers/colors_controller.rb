class ColorsController < ApplicationController
  before_action :set_color, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @colors = Color.paginate(:page => params[:page], :per_page => 100)
    respond_with(@colors)
  end

  def show
    respond_with(@color)
  end

  def new
    @color = Color.new
    respond_with(@color)
  end

  def edit
  end

  def create
    @color = Color.new(color_params)
    @color.save
    respond_with(@color)
  end

  def update
    @color.update(color_params)
    respond_with(@color)
  end

  def destroy
    @color.destroy
    respond_with(@color)
  end

  def import
    if request.post?
      msg = Message.new
      begin
        file=params[:files][0]
        fd = FileData.new(data: file, oriName: file.original_filename, path: $tmp_file_path, path_name: "#{Time.now.strftime('%Y%m%d%H%M%S%L')}~#{file.original_filename}")
        fd.save
        msg = FileHandler::Excel::ColorHandler.import(fd)
      rescue => e
        msg.content = e.message
      end
      render json: msg
    end
  end

  private
    def set_color
      @color = Color.find(params[:id])
    end

    def color_params
      params.require(:color).permit(:nr, :name, :short_name, :description)
    end
end
