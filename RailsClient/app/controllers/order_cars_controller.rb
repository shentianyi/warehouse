class OrderCarsController < ApplicationController
  before_action :set_order_car, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @order_cars = OrderCar.order(created_at: :desc).paginate(:page => params[:page], :per_page => 100)
    respond_with(@order_cars)
  end

  def show
    respond_with(@order_car)
  end

  def new
    @order_car = OrderCar.new
    respond_with(@order_car)
  end

  def edit
  end

  def create
    @order_car = OrderCar.new(order_car_params)
    @order_car.save
    respond_with(@order_car)
  end

  def update
    @order_car.update(order_car_params)
    respond_with(@order_car)
  end

  def destroy
    @order_car.destroy
    respond_with(@order_car)
  end

  def import
    if request.post?
      msg = Message.new
      begin
        file=params[:files][0]
        fd = FileData.new(data: file, oriName: file.original_filename, path: $tmp_file_path, pathName: "#{Time.now.strftime('%Y%m%d%H%M%S%L')}~#{file.original_filename}")
        fd.save
        msg = FileHandler::Excel::OrderCarHandler.import(fd)
      rescue => e
        msg.content = e.message
      end
      render json: msg
    end
  end

  private
    def set_order_car
      @order_car = OrderCar.find(params[:id])
    end

    def order_car_params
      params.require(:order_car).permit(:nr, :rfid_nr, :status, :whouse_id)
    end
end
