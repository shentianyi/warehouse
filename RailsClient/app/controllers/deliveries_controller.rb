class DeliveriesController < ApplicationController
  #load_and_authorize_resource
  before_action :set_delivery, only: [:show, :edit, :update, :destroy, :forklifts]
  skip_before_filter :delivery_params
  before_action :get_states, only: [:index, :search]
  #before_action :set_search_variable, only: [:search]
  # GET /deliveries
  # GET /deliveries.json
  def index
    @deliveries = Delivery.paginate(:page => params[:page]).order(created_at: :desc) #all
    #@deliveries = @deliveries.paginate(:page => params[:page])
  end

  # GET /deliveries/1
  # GET /deliveries/1.json
  def show
  end

  # GET /deliveries/new
  def new
    @delivery = Delivery.new
  end

  # GET /deliveries/1/edit
  def edit
  end

  # POST /deliveries
  # POST /deliveries.json
  def create
    @delivery = Delivery.new(delivery_params)

    respond_to do |format|
      if @delivery.save
        format.html { redirect_to @delivery, notice: 'Delivery was successfully created.' }
        format.json { render :show, status: :created, location: @delivery }
      else
        format.html { render :new }
        format.json { render json: @delivery.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /deliveries/1
  # PATCH/PUT /deliveries/1.json
  def update
    if delivery_params.has_key?(:state)
      DeliveryService.set_state(@delivery, delivery_params[:state])
    end
    respond_to do |format|
      if @delivery.update(delivery_params.permit(:state, :remark, :source_id, :destination_id))
        format.html { redirect_to @delivery, notice: '运单更新成功.' }
        format.json { render :show, status: :ok, location: @delivery }
      else
        format.html { render :edit }
        format.json { render json: @delivery.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /deliveries/1
  # DELETE /deliveries/1.json
  def destroy
    @delivery.destroy
    respond_to do |format|
      format.html { redirect_to deliveries_url, notice: 'Delivery was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /deliveries/1/forklifts
  def forklifts
    @forklifts = @delivery.forklifts.paginate(:page => params[:page]).order(created_at: :desc)
  end

  def export
    json={}
    # delivery,forklift,package,package_position
    d=Delivery.find(params[:id])
    json[:delivery]=d
    json[:forklifts]=d.forklifts
    json[:packages]=[]
    json[:forklifts].each { |f|
      json[:packages] += f.packages }
    json[:package_positions]= []
    json[:packages].each { |p|
      json[:package_positions]<< p.package_position }
    json[:state_logs]=d.state_logs
    json[:forklifts].each { |f|
      json[:state_logs]+=f.state_logs }
    json[:packages].each { |p|
      json[:state_logs]+=p.state_logs }
    send_data json.to_json, :filename => "#{d.id}.json"
  end

  def import
    if request.post?
      msg=Message.new
      begin
        if params[:files].size==1
          file=params[:files][0]
          data=FileData.new(data: file, oriName: file.original_filename, path: $DELIVERYPATH, pathName: "#{Time.now.strftime('%Y%m%d%H%M%S')}-#{file.original_filename}")
          data.saveFile
          msg=DeliveryService.import_by_file(data.full_path)
          msg.content= msg.result ? '运单导入成功' : '运单已存在，不可重复导入'
        else
          msg.content='未选择文件或只能上传一个文件'
        end
      rescue => e
        msg.content = e.message
      end
      render json: msg
    end
  end

  def generate
    if request.post?
      msg=Message.new
      if params[:files].size==1
        file=params[:files][0]
        data=FileData.new(data: file, oriName: file.original_filename, path: $DELIVERYPATH, pathName: "#{Time.now.strftime('%Y%m%d%H%M%S')}-#{file.original_filename}")
        data.saveFile
        DeliveryService.send_by_excel(data.full_path)
        msg.result =true
        msg.content= '导入成功'
      else
        msg.content='未选择文件或只能上传一个文件'
      end
      render json: msg
    end
  end

  def receive
    if request.post?
      msg=Message.new
      if params[:files].size==1
        file=params[:files][0]
        data=FileData.new(data: file, oriName: file.original_filename, path: $DELIVERYPATH, pathName: "#{Time.now.strftime('%Y%m%d%H%M%S')}-#{file.original_filename}")
        data.saveFile
        DeliveryService.receive_by_excel(data.full_path)
        msg.result =true
        msg.content= '导入成功'
      else
        msg.content='未选择文件或只能上传一个文件'
      end
      render json: msg
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_delivery
    @delivery = Delivery.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def delivery_params
    params.require(:delivery)
  end

  def get_states
    @states=DeliveryState.state #.insert(0, %w())
  end

  def set_search_variable
    p= params[:delivery]
    @id=p[:id]
    @user_id=p[:user_id]
    @receiver_id=p[:receiver_id]
    @state=p[:state]
    @delivery_date_start=p[:delivery_date][:start]
    @delivery_date_end=p[:delivery_date][:end]
    @received_date_start=p[:received_date][:start]
    @received_date_end=p[:received_date][:end]
  end
end
