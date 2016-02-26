# -*- coding: utf-8 -*-
class DeliveriesController < ApplicationController
  #2014-12-24 *no delivery model exists
  #load_and_authorize_resource
  before_action :set_delivery, only: [:show, :edit, :update, :destroy, :forklifts]
  skip_before_filter :delivery_params
  before_action :get_states, only: [:index, :search]
  #before_action :set_search_variable, only: [:search]
  # GET /deliveries
  # GET /deliveries.json
  def index
    @deliveries= DeliveryService.search(nil).order(created_at: :desc).paginate(:page => params[:page])
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
    #need to update
    respond_to do |format|
      if @delivery.update(delivery_params)

        if delivery_params.has_key? :state
          @delivery.descendants.each{|d| d.update({state: delivery_params[:state],is_dirty:true})}
        end

        if delivery_params.has_key? :des_location_id
          @delivery.descendants.each{|d| d.update({des_location_id: delivery_params[:des_location_id],is_dirty:true})}
        end

        # 注意修改了状态的后果
        format.html { redirect_to delivery_url(@delivery), notice: '运单更新成功.' }
        format.json { render :show, status: :ok, location: @delivery }
      else
        format.html { render :edit }
        format.json { render json: @delivery.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /deliveries/1
  # DELETE /deliveries/1.json
=begin
  def destroy
    @delivery.destroy
    respond_to do |format|
      format.html { redirect_to deliveries_url, notice: '运单成功删除.' }
      format.json { head :no_content }
    end
  end
=end

  # GET /deliveries/1/forklifts
  def forklifts
    dp = DeliveryPresenter.new(@delivery)
    @forklifts = dp.forklifts.paginate(:page => params[:page]).order(created_at: :desc)
  end

  def generate
    if request.post?
      msg=Message.new
      if params[:files].size==1
        file=params[:files][0]
        data=FileData.new(data: file, oriName: file.original_filename, path: $DELIVERYPATH, pathName: "#{Time.now.strftime('%Y%m%d%H%M%S')}-#{file.original_filename}")
        data.saveFile
        msg= DeliveryService.send_by_excel(data.full_path)
        #msg.result =true
        #msg.content= '导入成功'
      else
        msg.content='未选择文件或只能上传一个文件'
      end
      render json: msg
    end
  end

  def generate_jiaxuan
    if request.post?
      msg=Message.new
      if params[:files].size==1
        file=params[:files][0]
        data=FileData.new(data: file, oriName: file.original_filename, path: $DELIVERYPATH, pathName: "#{Time.now.strftime('%Y%m%d%H%M%S')}-#{file.original_filename}")
        data.saveFile
        msg= DeliveryService.send_jiaxuan_delivery(data.full_path, current_user)
        #msg.result =true
        #msg.content= '导入成功'
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
        msg=DeliveryService.receive_by_excel(data.full_path)
        #msg.result =true
        #msg.content= '导入成功'
      else
        msg.content='未选择文件或只能上传一个文件'
      end
      render json: msg
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_delivery
    @delivery = DeliveryService.search({id:params[:id]}).first
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def delivery_params
    params.require(:logistics_container).permit(:state, :remark,:des_location_id)
  end

  def get_states
    @states=MovableState.state
  end

=begin
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
    @created_at_start = p[:created_at_start][:start]
    @created_at_end = p[:created_at_end][:end]
    @source_id = p[:srouce_id]
  end
=end
end
