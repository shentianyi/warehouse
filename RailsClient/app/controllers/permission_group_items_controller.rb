class PermissionGroupItemsController < ApplicationController
  before_action :set_permission_group_item, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @permission_group_items = PermissionGroupItem.all
    respond_with(@permission_group_items)
  end

  def show
    respond_with(@permission_group_item)
  end

  def new
    @permission_group_item = PermissionGroupItem.new
    respond_with(@permission_group_item)
  end

  def edit
  end

  def create
    @permission_group_item = PermissionGroupItem.new(permission_group_item_params)
    @permission_group_item.save
    respond_with(@permission_group_item)
  end

  def update
    @permission_group_item.update(permission_group_item_params)
    respond_with(@permission_group_item)
  end

  def destroy
    @permission_group_item.destroy
    respond_with(@permission_group_item)
  end

  private
    def set_permission_group_item
      @permission_group_item = PermissionGroupItem.find(params[:id])
    end

    def permission_group_item_params
      params.require(:permission_group_item).permit(:permission_id, :permission_group_id)
    end
end
