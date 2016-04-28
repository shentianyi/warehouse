class LocationContainerPickListsController < ApplicationController
  before_action :set_location_container_pick_list, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @location_container_pick_lists = LocationContainerPickList.all
    respond_with(@location_container_pick_lists)
  end

  def show
    respond_with(@location_container_pick_list)
  end

  def new
    @location_container_pick_list = LocationContainerPickList.new
    respond_with(@location_container_pick_list)
  end

  def edit
  end

  def create
    @location_container_pick_list = LocationContainerPickList.new(location_container_pick_list_params)
    @location_container_pick_list.save
    respond_with(@location_container_pick_list)
  end

  def update
    @location_container_pick_list.update(location_container_pick_list_params)
    respond_with(@location_container_pick_list)
  end

  def destroy
    @location_container_pick_list.destroy
    respond_with(@location_container_pick_list)
  end

  private
    def set_location_container_pick_list
      @location_container_pick_list = LocationContainerPickList.find(params[:id])
    end

    def location_container_pick_list_params
      params.require(:location_container_pick_list).permit(:location_container_id, :pick_list_id)
    end
end
