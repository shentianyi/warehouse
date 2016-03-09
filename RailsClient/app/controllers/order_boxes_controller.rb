class OrderBoxesController < ApplicationController
  before_action :set_order_box, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @order_boxes = OrderBox.order(created_at: :desc).paginate(:page => params[:page], :per_page => 100)
    respond_with(@order_boxes)
  end

  def show
    respond_with(@order_box)
  end

  def new
    @order_box = OrderBox.new
    respond_with(@order_box)
  end

  def edit
  end

  def create
    @order_box = OrderBox.new(order_box_params)
    # @order_box.position=Position.find_by_id(params[:order_box][:position])
    @order_box.save
    respond_with(@order_box)
  end

  def update
    # p params[:order_box][:position]
    # @order_box.position=Position.find_by_id(params[:order_box][:position])

    @order_box.update(order_box_params)
    respond_with(@order_box)
  end

  def destroy
    @order_box.destroy
    respond_with(@order_box)
  end


  def import
    if request.post?
      msg = Message.new
      begin
        file=params[:files][0]
        fd = FileData.new(data: file, oriName: file.original_filename, path: $tmp_file_path, pathName: "#{Time.now.strftime('%Y%m%d%H%M%S%L')}~#{file.original_filename}")
        fd.save
        msg = FileHandler::Excel::OrderBoxHandler.import(fd)
      rescue => e
        msg.content = e.message
      end
      render json: msg
    end
  end

  private
    def set_order_box
      @order_box = OrderBox.find(params[:id])
    end

    def order_box_params
      params.require(:order_box).permit(:nr, :rfid_nr, :status, :part_id, :quantity, :order_box_type_id, :whouse_id, :source_whouse_id, :position_id)
    end
end
