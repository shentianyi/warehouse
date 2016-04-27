class BackPartsController < ApplicationController
  before_action :set_back_part, only: [:show, :edit, :update, :destroy, :back_part_items]

  respond_to :html

  def index
    @back_parts = BackPart.all
    respond_with(@back_parts)
  end

  def show
    respond_with(@back_part)
  end

  def new
    @back_part = BackPart.new
    respond_with(@back_part)
  end

  def edit
  end

  def create
    @back_part = BackPart.new(back_part_params)
    @back_part.save
    respond_with(@back_part)
  end

  def update
    @back_part.update(back_part_params)
    respond_with(@back_part)
  end

  def destroy
    @back_part.destroy
    respond_with(@back_part)
  end

  def back_part_items
    @back_part_items = @back_part.back_part_items.paginate(:page => params[:page])
    @page_start=(params[:page].nil? ? 0 : (params[:page].to_i-1))*20
  end

  private
    def set_back_part
      @back_part = BackPart.find(params[:id])
    end

    def back_part_params
      params.require(:back_part).permit(:user_id, :des_location_id, :src_location_id, :state)
    end
end
