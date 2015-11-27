class MovementListsController < ApplicationController
  before_action :set_movement_list, only: [:show, :edit, :update, :destroy, :movement_sources]

  respond_to :html

  def index
    @movement_lists = MovementList.all.paginate(:page => params[:page])
    respond_with(@movement_lists)
  end

  def show
    respond_with(@movement_list)
  end

  def new
    @movement_list = MovementList.new
    respond_with(@movement_list)
  end

  def edit
  end

  def create
    @movement_list = MovementList.new(movement_list_params)
    @movement_list.save
    respond_with(@movement_list)
  end

  def update
    @movement_list.update(movement_list_params)
    respond_with(@movement_list)
  end

  def destroy
    @movement_list.destroy
    respond_with(@movement_list)
  end

  def movement_sources
    @movement_sources = @movement_list.movement_sources.paginate(:page => params[:page])
    @page_start=(params[:page].nil? ? 0 : (params[:page].to_i-1))*20
  end

  private
    def set_movement_list
      @movement_list = MovementList.find(params[:id])
    end

    def movement_list_params
      params.require(:movement_list).permit(:uuid, :name, :state, :builder, :remarks)
    end
end