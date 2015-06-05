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
    @inventory_list_item.save
    respond_to do |format|
      if @inventory_list_item.save
        format.html { redirect_to @inventory_list_item, notice: 'InventoryListItem was successfully created.' }
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
        format.html { redirect_to inventory_list_items_path, notice: '修改成功' }
      else
        format.html { render :edit }
      end
    end
  end
  
  private
    def set_inventory_list_item
      @inventory_list_item = InventoryListItem.find(params[:id])
    end
    
   
    def inventory_list_item_params
      params.require(:inventory_list_item).permit(:package_id, :unique_id, :part_id, :qty, :position, :current_whouse, :current_position, :user_id, :in_store, :inventory_list_id)
    end
end
