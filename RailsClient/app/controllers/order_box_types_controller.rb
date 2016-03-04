class OrderBoxTypesController < ApplicationController
  before_action :set_order_box_type, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @order_box_types = OrderBoxType.order(created_at: :desc).paginate(:page => params[:page], :per_page => 100)
    respond_with(@order_box_types)
  end

  def show
    respond_with(@order_box_type)
  end

  def new
    @order_box_type = OrderBoxType.new
    respond_with(@order_box_type)
  end

  def edit
  end

  def create
    @order_box_type = OrderBoxType.new(order_box_type_params)
    @order_box_type.save
    respond_with(@order_box_type)
  end

  def update
    @order_box_type.update(order_box_type_params)
    respond_with(@order_box_type)
  end

  def destroy
    @order_box_type.destroy
    respond_with(@order_box_type)
  end

  def import
    if request.post?
      msg = Message.new
      begin
        file=params[:files][0]
        fd = FileData.new(data: file, oriName: file.original_filename, path: $tmp_file_path, pathName: "#{Time.now.strftime('%Y%m%d%H%M%S%L')}~#{file.original_filename}")
        fd.save
        msg = FileHandler::Excel::OrderBoxTypeHandler.import(fd)
      rescue => e
        msg.content = e.message
      end
      render json: msg
    end
  end

  private
    def set_order_box_type
      @order_box_type = OrderBoxType.find(params[:id])
    end

    def order_box_type_params
      params.require(:order_box_type).permit(:name, :description, :weight)
    end
end
