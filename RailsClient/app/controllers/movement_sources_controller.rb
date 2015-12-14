class MovementSourcesController < ApplicationController
  before_action :set_movement_source, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @movement_sources = MovementSource.all.paginate(:page => params[:page])
    respond_with(@movement_sources)
  end

  def show
    respond_with(@movement_source)
  end

  def new
    @movement_source = MovementSource.new
    respond_with(@movement_source)
  end

  def edit
  end

  def create
    @movement_source = MovementSource.new(movement_source_params)
    @movement_source.save
    respond_with(@movement_source)
  end

  def update
    @movement_source.update(movement_source_params)
    respond_with(@movement_source)
  end

  def destroy
    @movement_source.destroy
    respond_with(@movement_source)
  end

  private
    def set_movement_source
      @movement_source = MovementSource.find(params[:id])
    end

    def movement_source_params
      params.require(:movement_source).permit(:movement_list_id, :fromWh, :fromPosition, :packageId, :partNr, :qty, :fifo, :toWh, :toPosition, :employee_id, :remarks)
    end
end
