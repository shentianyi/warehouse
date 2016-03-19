class ForkliftsController < ApplicationController
  #load_and_authorize_resource
  before_action :set_forklift, only: [:show, :edit, :update, :destroy,:packages]

  # GET /forklifts
  # GET /forklifts.json
  def index
    @forklifts = ForkliftService.search(nil,true,current_user.location).order(created_at: :desc).paginate(:page=>params[:page])#all
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
=begin
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
=end

  # PATCH/PUT /forklifts/1
  # PATCH/PUT /forklifts/1.json
  def update

    #现在不能修改备货仓库了。
    respond_to do |format|
      if @forklift.update(forklift_params)

        if forklift_params.has_key? :state
          @forklift.descendants.each{|d| d.update({state: forklift_params[:state],is_dirty:true})}
        end

        format.html { redirect_to forklift_url(@forklift), notice: '托盘更新成功' }
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
    @packages = ForkliftPresenter.new(@forklift).packages.paginate(:page=>params[:page]).order(created_at: :desc)
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_forklift
    @forklift = ForkliftService.search({id:params[:id]}).first
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def forklift_params
    #params[:forklift]
    params.require(:logistics_container).permit(:state,:remark)
  end

=begin
  def set_search_variable
    p= params[:forklift]
    @id=p[:id]
    @stocker_id=p[:stocker_id]
    @state=p[:state]
    @created_at_start=p[:created_at][:start]
    @created_at_end=p[:created_at][:end]
  end
=end
end
