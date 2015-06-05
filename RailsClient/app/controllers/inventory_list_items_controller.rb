class InventoryListItemsController < ApplicationController
  
  before_action :set_inventory_list_item, only: [:show, :edit, :update, :destroy]

  respond_to :html
  
  def index
    @inventory_list_items = InventoryListItem.paginate(:page => params[:page])
    respond_with(@inventory_list_items)
  end

  def new
  end

  def create
  end
  
  private
    def set_inventory_list_item
      @inventory_list_item = InventoryListItem.find(params[:id])
    end

    def inventory_list_item_params
      params.require(:inventory_list_item).permit(:name, :state, :whouse_id, :user_id)
    end
end
