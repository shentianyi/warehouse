class LocationContainerOrdersController < ApplicationController
  before_action :set_location_container_order, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @location_container_orders = LocationContainerOrder.all
    respond_with(@location_container_orders)
  end

  def show
    respond_with(@location_container_order)
  end

  def new
    @location_container_order = LocationContainerOrder.new
    respond_with(@location_container_order)
  end

  def edit
  end

  def create
    @location_container_order = LocationContainerOrder.new(location_container_order_params)
    @location_container_order.save
    respond_with(@location_container_order)
  end

  def update
    @location_container_order.update(location_container_order_params)
    respond_with(@location_container_order)
  end

  def destroy
    @location_container_order.destroy
    respond_with(@location_container_order)
  end

  private
    def set_location_container_order
      @location_container_order = LocationContainerOrder.find(params[:id])
    end

    def location_container_order_params
      params.require(:location_container_order).permit(:location_container_id, :order_id)
    end
end
