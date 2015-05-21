class NStoragesController < ApplicationController
  before_action :set_storage, only: [:show, :edit, :update, :destroy]

# GET /deliveries
  def index
    @n_storages= NStorage.paginate(:page => params[:page])
  end

  def search
    @n_storages=NStorage
    if params[:partNr].present?
      @n_storages=@n_storages.where("partNr like '%#{params[:partNr]}%'")
      @partNr=params[:partNr]
    end
    @n_storages=@n_storages.paginate(:page => params[:page])
    render :index
  end


  def update
    respond_to do |format|
      if @storage.update(storage_params)
        format.html { redirect_to @storage, notice: 'Storage was successfully updated.' }
        format.json { render :show, status: :ok, location: @storage }
      else
        format.html { render :edit }
        format.json { render json: @storage.errors, status: :unprocessable_entity }
      end
    end
  end

  private
# Use callbacks to share common setup or constraints between actions.
  def set_storage
    @storage = NStorage.unscoped.find(params[:id])
  end

  def storage_params
    #params[:order_item]
    params.require(:n_storage).permit(:partNr, :packageId,:ware_house_id,:position,:qty)
  end
end
