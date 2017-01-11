class LedsController < ApplicationController
  before_action :set_led, only: [:show, :edit, :update, :destroy]

  # GET /leds
  # GET /leds.json
  def index
    @leds = Led.paginate(:page=> params[:page]).order(:nr,:modem_id)
  end

  # GET /leds/1
  # GET /leds/1.json
  def show
  end

  # GET /leds/new
  def new
    @led = Led.new
  end

  # GET /leds/1/edit
  def edit
  end

  # POST /leds
  # POST /leds.json
  def create
    # args = {}
    # args[:id] = led_params[:id]
    # args[:position_id] = Position.find_by_detail(led_params[:position_id]).id
    # args[:current_state] = led_params[:current_state]
    @led = Led.new(led_params)

    respond_to do |format|
      if @led.save
        format.html { redirect_to @led, notice: 'Led was successfully created.' }
        format.json { render :show, status: :created, location: @led }
      else
        format.html { render :new }
        format.json { render json: @led.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /leds/1
  # PATCH/PUT /leds/1.json
  def update
    respond_to do |format|
      if @led.update(led_params)
        format.html { redirect_to @led, notice: 'Led was successfully updated.' }
        format.json { render :show, status: :ok, location: @led }
      else
        format.html { render :edit }
        format.json { render json: @led.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /leds/1
  # DELETE /leds/1.json
  def destroy
    @led.destroy
    respond_to do |format|
      format.html { redirect_to leds_url, notice: 'Led was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def import
    if request.post?
      msg = Message.new
      begin
        file=params[:files][0]
        fd = FileData.new(data: file, oriName: file.original_filename, path: $tmp_file_path, pathName: "#{Time.now.strftime('%Y%m%d%H%M%S%L')}~#{file.original_filename}")
        fd.save
        msg = FileHandler::Excel::LedHandler.import(fd)
      rescue => e
        msg.content = e.message
      end
      render json: msg
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_led
      @led = Led.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def led_params
      params.require(:led).permit( :id, :name, :modem_id, :position_id,:current_state,
                                   :led_display,:mac, :order_box_id, :order_car_id, :nr)
    end
end
