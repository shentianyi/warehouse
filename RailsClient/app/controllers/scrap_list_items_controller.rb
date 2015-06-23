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
    # @scrap_list_item = ScrapListItem.new
    # respond_with(@scrap_list_item)
    @scrap_list=ScrapList.find_by_id(params[:id])
    session[:scrap_list_id]=params[:id]
  end

  def edit
  end

  def create
    @scrap_list_item = ScrapListItem.new(scrap_list_item_params)
    @scrap_list_item.save
    respond_with(@scrap_list_item)
  end

  def update
    respond_to do |format|
      if @scrap_list_item.update(scrap_list_item_params)
        format.html { redirect_to @scrap_list_item, notice: 'successfully updated.' }
        format.json { render :show, status: :ok, location: @scrap_list_item }
      else
        format.html { render :edit }
        format.json { render json: @scrap_list_item.errors, status: :unprocessable_entity }
      end
    end
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
        msg = FileHandler::Excel::ScrapListItemHandler.import(fd,session[:scrap_list_id])
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
