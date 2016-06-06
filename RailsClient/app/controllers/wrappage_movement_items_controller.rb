class WrappageMovementItemsController < ApplicationController
  before_action :set_wrappage_movement_item, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @wrappage_movement_items = WrappageMovementItem.all
    respond_with(@wrappage_movement_items)
  end

  def show
    respond_with(@wrappage_movement_item)
  end

  def new
    @wrappage_movement_item = WrappageMovementItem.new
    respond_with(@wrappage_movement_item)
  end

  def edit
  end

  def create
    @wrappage_movement_item = WrappageMovementItem.new(wrappage_movement_item_params)
    @wrappage_movement_item.save
    respond_with(@wrappage_movement_item)
  end

  def update
    @wrappage_movement_item.update(wrappage_movement_item_params)
    respond_with(@wrappage_movement_item)
  end

  def destroy
    @wrappage_movement_item.destroy
    respond_with(@wrappage_movement_item)
  end

  private
    def set_wrappage_movement_item
      @wrappage_movement_item = WrappageMovementItem.find(params[:id])
    end

    def wrappage_movement_item_params
      params.require(:wrappage_movement_item).permit(:wrappage_movement_id, :src_location_id, :des_location_id, :qty, :wrappage_move_type_id, :user_id, :sourceable_id, :sourceable_type, :extra_800_nos, :extra_leoni_out_no)
    end
end
