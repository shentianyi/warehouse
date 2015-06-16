class ScrapListItemsController < ApplicationController
  before_action :set_scrap_list_item, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @scrap_list_items = ScrapListItem.all
    respond_with(@scrap_list_items)
  end

  def show
    respond_with(@scrap_list_item)
  end

  def new
    @scrap_list_item = ScrapListItem.new
    respond_with(@scrap_list_item)
  end

  def edit
  end

  def create
    @scrap_list_item = ScrapListItem.new(scrap_list_item_params)
    @scrap_list_item.save
    respond_with(@scrap_list_item)
  end

  def update
    @scrap_list_item.update(scrap_list_item_params)
    respond_with(@scrap_list_item)
  end

  def destroy
    @scrap_list_item.destroy
    respond_with(@scrap_list_item)
  end

  def import
    if request.post?
      msg = Message.new
      begin
        file=params[:files][0]
        fd = FileData.new(data: file, oriName: file.original_filename, path: $tmp_file_path, pathName: "#{Time.now.strftime('%Y%m%d%H%M%S%L')}~#{file.original_filename}")
        fd.save
        msg = FileHandler::Excel::ScrapListItemHandler.import(fd)
      rescue => e
        msg.content = e.message
      end
      render json: msg
    end
  end

  private
    def set_scrap_list_item
      @scrap_list_item = ScrapListItem.find(params[:id])
    end

    def scrap_list_item_params
      params.require(:scrap_list_item).permit(:scrap_list_id, :part_id, :product_id, :quantity, :IU, :reason, :name, :time)
    end
end
