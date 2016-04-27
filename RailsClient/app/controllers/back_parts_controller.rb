class BackPartsController < ApplicationController
  before_action :set_back_part, only: [:show, :edit, :update, :destroy, :back_part_items]

  respond_to :html

  def index
    @back_parts = BackPart.all
    respond_with(@back_parts)
  end

  def show
    respond_with(@back_part)
  end

  def new
    @back_part = BackPart.new
    respond_with(@back_part)
  end

  def edit
  end

  def create
    @back_part = BackPart.new(back_part_params)
    @back_part.save
    respond_with(@back_part)
  end

  def update
    @back_part.update(back_part_params)
    respond_with(@back_part)
  end

  def destroy
    @back_part.destroy
    respond_with(@back_part)
  end

  def back_part_items
    @back_part_items = @back_part.back_part_items.paginate(:page => params[:page])
    @page_start=(params[:page].nil? ? 0 : (params[:page].to_i-1))*20
  end

  def print
    msg=Message.new
    begin
      puts SysConfigCache.print_server_value
      msg= RestClient::Resource.new("#{SysConfigCache.print_server_value}/printer/print/P011/#{params[:id]}",
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
    def set_back_part
      @back_part = BackPart.find(params[:id])
    end

    def back_part_params
      params.require(:back_part).permit(:user_id, :des_location_id, :src_location_id, :state)
    end
end
