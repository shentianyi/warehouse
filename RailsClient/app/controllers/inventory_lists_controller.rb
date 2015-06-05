class InventoryListsController < ApplicationController
  before_action :set_inventory_list, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
   
    @inventory_lists = InventoryList.paginate(:page => params[:page])
    respond_with(@inventory_lists)
  end

  def show
    respond_with(@inventory_list)
  end

  def new
    @inventory_list = InventoryList.new
    respond_with(@inventory_list)
  end

  def edit
  end

  def create
    @inventory_list = InventoryList.new(inventory_list_params)
    @inventory_list.user_id = current_user.id
    @inventory_list.save
    respond_to do |format|
      if @inventory_list.save
        format.html { redirect_to @inventory_list, notice: 'InventoryList was successfully created.' }
        format.json { render :show, status: :created, location: @inventory_list }
      else
        format.html { render :new }
        format.json { render json: @inventory_list.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @inventory_list.update(inventory_list_params)
    respond_with(@inventory_list)
  end

  def destroy
    @inventory_list.destroy
    respond_with(@inventory_list)
  end

  private
    def set_inventory_list
      @inventory_list = InventoryList.find(params[:id])
    end

    def inventory_list_params
      params.require(:inventory_list).permit(:package_id, :unique_id, :part_id, :qty, :position, :current_whouse, :current_position, :user_id, :in_store, :inventory_list_id)
    end
end
