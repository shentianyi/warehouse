class ForkliftsController < ApplicationController
  #load_and_authorize_resource
  before_action :set_forklift, only: [:show, :edit, :update, :destroy,:packages]

  # GET /forklifts
  # GET /forklifts.json
  def index
    @forklifts = Forklift.paginate(:page=>params[:page]).order(created_at: :desc)#all
    #@forklifts = @forklifts.paginate(:page=>params[:page])
  end

  # GET /forklifts/1
  # GET /forklifts/1.json
  def show
  end

  # GET /forklifts/new
  def new
    @forklift = Forklift.new
  end

  # GET /forklifts/1/edit
  def edit
  end

  # POST /forklifts
  # POST /forklifts.json
  def create
    @forklift = Forklift.new(forklift_params)

    respond_to do |format|
      if @forklift.save
        format.html { redirect_to @forklift, notice: '托盘新建成功' }
        format.json { render :show, status: :created, location: @forklift }
      else
        format.html { render :new }
        format.json { render json: @forklift.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /forklifts/1
  # PATCH/PUT /forklifts/1.json
  def update
    if forklift_params.has_key?(:state)
      ForkliftService.set_state(@forklift,forklift_params[:state])
    end

    respond_to do |format|
      if @forklift.update(forklift_params)
        format.html { redirect_to @forklift, notice: '托盘更新成功' }
        format.json { render :show, status: :ok, location: @forklift }
      else
        format.html { render :edit }
        format.json { render json: @forklift.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /forklifts/1
  # DELETE /forklifts/1.json
  def destroy
    @forklift.destroy
    respond_to do |format|
      format.html { redirect_to forklifts_url, notice: '托盘删除成功' }
      format.json { head :no_content }
    end
  end

  # GET /forklifts/1/packages
  def packages
    @packages = @forklift.packages.paginate(:page=>params[:page]).order(created_at: :desc)
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_forklift
    @forklift = Forklift.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def forklift_params
    #params[:forklift]
    params.require(:forklift).permit(:state,:remark,:whouse_id)
    end

  def set_search_variable
    p= params[:forklift]
    @id=p[:id]
    @stocker_id=p[:stocker_id]
    @state=p[:state]
    @created_at_start=p[:created_at][:start]
    @created_at_end=p[:created_at][:end]
  end
end
