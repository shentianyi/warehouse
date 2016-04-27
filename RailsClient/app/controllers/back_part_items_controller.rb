class BackPartItemsController < ApplicationController
  before_action :set_back_part_item, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @back_part_items = BackPartItem.all
    respond_with(@back_part_items)
  end

  def show
    respond_with(@back_part_item)
  end

  def new
    @back_part_item = BackPartItem.new
    respond_with(@back_part_item)
  end

  def edit
  end

  def create
    @back_part_item = BackPartItem.new(back_part_item_params)
    @back_part_item.save
    respond_with(@back_part_item)
  end

  def update
    @back_part_item.update(back_part_item_params)
    respond_with(@back_part_item)
  end

  def destroy
    @back_part_item.destroy
    respond_with(@back_part_item)
  end

  def import
    if request.get?
      @back_part=BackPart.find_by_id(params[:id])
      session[:back_part_id]=params[:id]
    else
      msg = Message.new
      begin
        file=params[:files][0]
        fd = FileData.new(data: file, oriName: file.original_filename, path: $tmp_file_path, pathName: "#{Time.now.strftime('%Y%m%d%H%M%S%L')}~#{file.original_filename}")
        fd.save
        msg = FileHandler::Excel::BackPartItemHandler.import(fd, session[:back_part_id])
      rescue => e
        msg.content = e.message
      end
      render json: msg
    end
  end

  private
    def set_back_part_item
      @back_part_item = BackPartItem.find(params[:id])
    end

    def back_part_item_params
      params.require(:back_part_item).permit(:back_part_id, :part_id, :qty, :back_reason, :has_sample, :remark, :whouse_id, :position_id)
    end
end
