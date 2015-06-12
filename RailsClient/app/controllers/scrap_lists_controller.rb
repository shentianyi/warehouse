class ScrapListsController < ApplicationController
  before_action :set_scrap_list, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @scrap_lists = ScrapList.all
    respond_with(@scrap_lists)
  end

  def show
    respond_with(@scrap_list)
  end

  def new
    @scrap_list = ScrapList.new
    respond_with(@scrap_list)
  end

  def edit
  end

  def create
    @scrap_list = ScrapList.new(scrap_list_params)
    @scrap_list.save
    respond_with(@scrap_list)
  end

  def update
    @scrap_list.update(scrap_list_params)
    respond_with(@scrap_list)
  end

  def destroy
    @scrap_list.destroy
    respond_with(@scrap_list)
  end

  def scrap_list_items

  end

  private
    def set_scrap_list
      @scrap_list = ScrapList.find(params[:id])
    end

    def scrap_list_params
      params.require(:scrap_list).permit(:src_warehouse, :dse_warehouse, :builder)
    end
end
