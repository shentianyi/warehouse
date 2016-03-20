class PickListsController < ApplicationController
  before_action :set_pick_list, only: [:show, :edit, :update, :destroy]

  # GET /pick_lists
  # GET /pick_lists.json
  def index
    @pick_lists = PickList.paginate(:page => params[:page]).order(created_at: :desc) #all
  end

  # GET /pick_lists/1
  # GET /pick_lists/1.json
  def show
    @back_url = params.has_key?(:show) ? '/pick_lists' : '/orders/panel'
    @pick_items=@pick_list.pick_items.order(state: :asc, is_emergency: :desc)
  end

  # GET /pick_lists/new
  def new
    @pick_list = PickList.new
  end

  # GET /pick_lists/1/edit
  def edit
  end

  # POST /pick_lists
  # POST /pick_lists.json
  def create
    msg=Message.new
    if user=User.find_by_nr(params[:user_id])
      params[:user_id]=user.id
    end
    pick_list=PickListService.covert_order_to_pick_list(params[:user_id], params[:order_ids])
    if pick_list
      msg.result = true
      msg.content = pick_list
    end
    render json: msg
  end

  # PATCH/PUT /pick_lists/1
  # PATCH/PUT /pick_lists/1.json
  def update
    respond_to do |format|
      if @pick_list.update(pick_list_params)
        format.html { redirect_to @pick_list, notice: 'Pick list was successfully updated.' }
        format.json { render :show, status: :ok, location: @pick_list }
      else
        format.html { render :edit }
        format.json { render json: @pick_list.errors, status: :unprocessable_entity }
      end
    end
  end

  def export
    pick_list_id =  params["pick-list-check"].blank? ? '' : params["pick-list-check"].keys.first

    if !pick_list_id.blank?
      pick_items = PickItem.where(pick_list_id: pick_list_id)
      send_data(PickItem.to_total_xlsx(pick_items),
                :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet",
                :filename => "择货单#{pick_list_id}详细导出.xlsx")
    else
      redirect_to :back, notice: '请选择需要导出的择货单.'
    end
  end

  # DELETE /pick_lists/1
  # DELETE /pick_lists/1.json
  def destroy
    @pick_list.destroy
    respond_to do |format|
      format.html { redirect_to pick_lists_url, notice: 'Pick list was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def print
    msg=Message.new
    begin
      puts SysConfigCache.print_server_value
      msg= RestClient::Resource.new("#{SysConfigCache.print_server_value}/printer/print/P006/#{params[:id]}",
                                    :timeout => 20,
                                    :open_timeout => 20,
                                    'content_type' => 'application/json').get
    rescue
      msg.result
      msg.content='无法连接打印服务器，请重新配置'
    end
    msg.result =true
    render json: msg
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_pick_list
    @pick_list = PickList.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def pick_list_params
    params #.require(:pick_list).permit(:id, :user_id)
  end
end
