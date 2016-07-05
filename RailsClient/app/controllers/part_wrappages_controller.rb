class PartWrappagesController < ApplicationController
  before_action :set_part_wrappage, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @part_wrappages = PartWrappage.all
    respond_with(@part_wrappages)
  end

  def show
    respond_with(@part_wrappage)
  end

  def new
    @part_wrappage = PartWrappage.new
    respond_with(@part_wrappage)
  end

  def edit
  end

  def create
    @part_wrappage = PartWrappage.new(part_wrappage_params)
    @part_wrappage.save
    respond_with(@part_wrappage)
  end

  def update
    @part_wrappage.update(part_wrappage_params)
    respond_with(@part_wrappage)
  end

  def destroy
    @part_wrappage.destroy
    respond_with(@part_wrappage)
  end

  private
    def set_part_wrappage
      @part_wrappage = PartWrappage.find(params[:id])
    end

    def part_wrappage_params
      params.require(:part_wrappage).permit(:part_id, :wrappage_id, :capacity)
    end
end
