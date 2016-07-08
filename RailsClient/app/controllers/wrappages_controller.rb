class WrappagesController < ApplicationController
  before_action :set_wrappage, only: [:show, :edit, :update, :destroy, :part_wrappages]

  respond_to :html

  def index
    @wrappages = Wrappage.all.paginate(:page => params[:page])
    respond_with(@wrappages)
  end

  def show
    respond_with(@wrappage)
  end

  def new
    @wrappage = Wrappage.new
    respond_with(@wrappage)
  end

  def edit
  end

  def create
    @wrappage = Wrappage.new(wrappage_params)
    @wrappage.save
    respond_with(@wrappage)
  end

  def update
    @wrappage.update(wrappage_params)
    respond_with(@wrappage)
  end

  def destroy
    @wrappage.destroy
    respond_with(@wrappage)
  end

  def part_wrappages
    @part_wrappages = @wrappage.part_wrappages.paginate(:page => params[:page])
    @page_start=(params[:page].nil? ? 0 : (params[:page].to_i-1))*20
  end

  def import
    if request.get?
      # @back_part=BackPart.find_by_id(params[:id])
      # session[:back_part_id]=params[:id]
    else
      msg = Message.new
      begin
        file=params[:files][0]
        fd = FileData.new(data: file, oriName: file.original_filename, path: $tmp_file_path, pathName: "#{Time.now.strftime('%Y%m%d%H%M%S%L')}~#{file.original_filename}")
        fd.save
        msg = FileHandler::Excel::WrappageHandler.import(fd)
      rescue => e
        msg.content = e.message
      end
      render json: msg
    end
  end

  def import_parts
    if request.get?
      # @back_part=BackPart.find_by_id(params[:id])
      # session[:back_part_id]=params[:id]
    else
      msg = Message.new
      begin
        file=params[:files][0]
        fd = FileData.new(data: file, oriName: file.original_filename, path: $tmp_file_path, pathName: "#{Time.now.strftime('%Y%m%d%H%M%S%L')}~#{file.original_filename}")
        fd.save
        msg = FileHandler::Excel::WrappageHandler.import_parts(fd)
      rescue => e
        msg.content = e.message
      end
      render json: msg
    end
  end

  def import_stock
    if request.get?
      # @back_part=BackPart.find_by_id(params[:id])
      # session[:back_part_id]=params[:id]
    else
      msg = Message.new
      begin
        file=params[:files][0]
        fd = FileData.new(data: file, oriName: file.original_filename, path: $tmp_file_path, pathName: "#{Time.now.strftime('%Y%m%d%H%M%S%L')}~#{file.original_filename}")
        fd.save
        msg = FileHandler::Excel::WrappageHandler.import_stock(fd, current_user)
      rescue => e
        msg.content = e.message
      end
      render json: msg
    end
  end

  private
    def set_wrappage
      @wrappage = Wrappage.find(params[:id])
    end

    def wrappage_params
      params.require(:wrappage).permit(:nr, :name, :desc)
    end
end
