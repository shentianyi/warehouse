class WhousesController < ApplicationController
  #load_and_authorize_resource
  before_action :set_whouse, only: [:show, :edit, :update, :destroy, :positions]

  # GET /whouses
  # GET /whouses.json
  def index
    @whouses = Whouse.order(location_id: :desc).paginate(:page => params[:page])#all
    #@whouses = @whouses.paginate(:page=>params[:page])
  end

  # GET /whouses/1
  # GET /whouses/1.json
  def show
  end

  # GET /whouses/new
  def new
    @whouse = Whouse.new
  end

  # GET /whouses/1/edit
  def edit
  end

  # POST /whouses
  # POST /whouses.json
  def create
    @whouse = Whouse.new(whouse_params)

    respond_to do |format|
      if @whouse.save
        format.html { redirect_to @whouse, notice: 'Whouse was successfully created.' }
        format.json { render :show, status: :created, location: @whouse }
      else
        format.html { render :new }
        format.json { render json: @whouse.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /whouses/1
  # PATCH/PUT /whouses/1.json
  def update
    respond_to do |format|
      if @whouse.update(whouse_params)
        format.html { redirect_to @whouse, notice: 'Whouse was successfully updated.' }
        format.json { render :show, status: :ok, location: @whouse }
      else
        format.html { render :edit }
        format.json { render json: @whouse.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /whouses/1/whouses
  def positions
    @positions = @whouse.positions.paginate(:page => params[:page])
  end

  # DELETE /whouses/1
  # DELETE /whouses/1.json
  def destroy
    @whouse.destroy
    respond_to do |format|
      format.html { redirect_to whouses_url, notice: 'Whouse was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_whouse
      @whouse = Whouse.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def whouse_params
      #params[:whouse]
      params.require(:whouse).permit(:id,:name,:location_id,:nr)
    end
end
