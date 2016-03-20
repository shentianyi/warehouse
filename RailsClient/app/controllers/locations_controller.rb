class LocationsController < ApplicationController
  load_and_authorize_resource
  before_action :set_location, only: [:show, :edit, :update, :destroy, :users, :whouses, :destinations, :add_destination, :remove_destination, :set_default_destination]

  # GET /locations
  # GET /locations.json
  def index
    @locations = Location.paginate(:page => params[:page]) #all
    #@locations = @locations.paginate(:page=>params[:page])
  end

  # GET /locations/1
  # GET /locations/1.json
  def show
  end

  # GET /locations/new
  def new
    @location = Location.new
  end

  # GET /locations/1/edit
  def edit
  end

  # POST /locations
  # POST /locations.json
  def create
    #@location = Location.new(params.require(:location).permit(:id,:name,:address,:tel))
    @location = Location.new(location_params)

    respond_to do |format|
      if @location.save
        format.html { redirect_to @location, notice: '地点创建成功' }
        format.json { render :show, status: :created, location: @location }
      else
        format.html { render :new }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  def destinations

  end

  def add_destination
    if @location.destinations.include?(Location.find_by_id(location_params[:destination_id]))
      redirect_to destinations_location_path(@location), notice: '目的地已存在'
    end

    if @location.location_destinations.count == 0
      d = @location.location_destinations.build({destination_id: location_params[:destination_id], is_default: true})
    else
      d = @location.location_destinations.build({destination_id: location_params[:destination_id]})
    end

    if d.save
      redirect_to destinations_location_path(@location), notice: '添加成功'
    else
      redirect_to destinations_location_path(@location), notice: d.errors.full_messages.to_json
    end
  end

  def remove_destination
    d = @location.location_destinations.where({destination_id: params[:destination_id]}).first
    d.destroy
    render :destinations
    #render :json => d.errors.full_messages.to_json
  end

  def set_default_destination
    unless @location.destinations.include?(Location.find_by_id(params[:destination_id]))
      redirect_to destinations_location_path(@location), notice: '目的地未找到'
    end

    @location.location_destinations.where({is_default: true}).first.update({is_default: false})

    d = @location.location_destinations.where({destination_id: params[:destination_id]}).first
    @location.update(destination_id: params[:destination_id])
    if d.update({is_default: true})
      redirect_to destinations_location_path(@location), notice: '设置成功'
    else
      redirect_to destinations_location_path(@location), notice: '设置失败'
    end
  end

  # GET /locations/1/users
  def users
    @users = @location.users.paginate(:page => params[:page])
  end

  # GET /locations/1/whouses
  def whouses
    @whouses = @location.whouses.paginate(:page => params[:page])
  end

  # PATCH/PUT /locations/1
  # PATCH/PUT /locations/1.json
  def update
    respond_to do |format|
      puts '##########################'
      puts location_params
      puts '##########################'
      if @location.update(location_params)
        format.html { redirect_to @location, notice: '地点更新成功.' }
        format.json { render :show, status: :ok, location: @location }
      else
        format.html { render :edit }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /locations/1
  # DELETE /locations/1.json
  def destroy
    # if @location.is_base
    #   respond_to do |format|
    #     format.html { redirect_to locations_url, notice: '基础地点不可删除.' }
    #     format.json { head :no_content }
    #   end
    # else
    @location.destroy
    respond_to do |format|
      format.html { redirect_to locations_url, notice: '地点删除成功.' }
      format.json { head :no_content }
    end
    # end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_location
    @location = Location.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def location_params
    #params[:location]
    params.require(:location).permit(:name, :address, :tel, :id,:nr,
                                     :prefix, :suffix,:receive_whouse_id,:send_whouse_id,
                                     :order_source_location_id,:receive_mode, :destination_id,:tenant_id,
    :is_open_safe_qty,:safe_qty_emails)
  end
end
