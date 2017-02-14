class PickOrdersController < ApplicationController
  before_action :set_pick_order, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @pick_orders = PickOrder.all
    respond_with(@pick_orders)
  end

  def show
    respond_with(@pick_order)
  end

  def new
    @pick_order = PickOrder.new
    respond_with(@pick_order)
  end

  def edit
  end

  def create
    @pick_order = PickOrder.new(pick_order_params)
    @pick_order.save
    respond_with(@pick_order)
  end

  def update
    @pick_order.update(pick_order_params)
    respond_with(@pick_order)
  end

  def destroy
    @pick_order.destroy
    respond_with(@pick_order)
  end

  private
    def set_pick_order
      @pick_order = PickOrder.find(params[:id])
    end

    def pick_order_params
      params.require(:pick_order).permit(:order_id, :pick_list_id)
    end
end
