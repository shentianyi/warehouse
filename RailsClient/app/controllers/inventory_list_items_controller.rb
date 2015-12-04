class InventoryListItemsController < ApplicationController

  before_action :set_inventory_list_item, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @inventory_list_items = InventoryListItem.paginate(:page => params[:page])
    respond_with(@inventory_list_items)
  end

  def new
    @inventory_list_item = InventoryListItem.new
    respond_with(@inventory_list_item)
  end

  def create
    @inventory_list_item = InventoryListItem.new(inventory_list_item_params)
    @inventory_list_item.user_id = current_user.id
    # @inventory_list_item.save
    respond_to do |format|
      if @inventory_list_item.save
        format.html { redirect_to inventory_list_items_path, notice: '创建成功.' }
        format.json { render :show, status: :created, location: @inventory_list_item }
      else
        format.html { render :new }
        format.json { render json: @inventory_list_item.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @inventory_list_item.update(inventory_list_item_params)
        format.html { redirect_to @inventory_list_item, notice: 'successfully updated.' }
        format.json { render json: 1, status: :ok }
      else
        format.html { render :edit }
        format.json { render json: @inventory_list_item.errors, status: :unprocessable_entity }
      end
    end
  end


  def import
    if request.get?
      @inventory_list=InventoryList.find_by_id(params[:id])
      session[:inventory_list_id]=params[:id]
    else
      msg = Message.new
      begin
        file=params[:files][0]
        fd = FileData.new(data: file, oriName: file.original_filename, path: $tmp_file_path, pathName: "#{Time.now.strftime('%Y%m%d%H%M%S%L')}~#{file.original_filename}")
        fd.save
        msg = FileHandler::Excel::InventoryListItemHandler.import(fd, session[:inventory_list_id])
      rescue => e
        msg.content = e.message
      end
      render json: msg
    end
  end

  def export_list_detail
    @inventory_list=InventoryList.find_by_id(params[:id])
    msg = FileHandler::Excel::InventoryListItemHandler.export_detail(@inventory_list.inventory_list_items)
    send_file msg.content
  end

  def export_list_total
    @inventory_list=InventoryList.find_by_id(params[:id])
    msg = FileHandler::Excel::InventoryListItemHandler.export_total(
        @inventory_list.inventory_list_items.group('whouse_id,part_id,fifo').select('*,sum(qty) as qty'))
    send_file msg.content
  end

  def lock_unlock_list
    @inventory_list=InventoryList.find_by_id(params[:id])
    InventoryListItem.transaction do
      @inventory_list.inventory_list_items.where("package_id<>''").each do |item|
        if s=NStorage.unscoped.where(packageId: item.package_id).first
          puts item.package_id
          s.update_attributes(locked: !item.locked)
          item.update_attributes(locked: !item.locked)
        end if item.package_id.present?
      end
    end
    @inventory_list_items=@inventory_list.inventory_list_items.paginate(:page => params[:page])
    @page_start=(params[:page].nil? ? 0 : (params[:page].to_i-1))*20

    render 'inventory_lists/inventory_list_items'
  end


  def store_list
    @inventory_list=InventoryList.find_by_id(params[:id])
    InventoryListItem.transaction do
      @inventory_list.inventory_list_items.where(in_stored: false).each do |item|
        item.enter_stock
        item.update_attributes(in_stored: true)
      end
    end
    @inventory_list_items=@inventory_list.inventory_list_items.paginate(:page => params[:page])
    @page_start=(params[:page].nil? ? 0 : (params[:page].to_i-1))*20

    render 'inventory_lists/inventory_list_items'
  end

  private
  def set_inventory_list_item
    @inventory_list_item = InventoryListItem.find(params[:id])
  end


  def inventory_list_item_params
    params.require(:inventory_list_item).permit(:package_id, :unique_id, :part_id, :qty, :origin_qty, :position, :current_whouse, :current_position, :user_id, :in_store, :inventory_list_id, :fifo_display, :part_form_mark, :part_wire_mark)
  end
end
