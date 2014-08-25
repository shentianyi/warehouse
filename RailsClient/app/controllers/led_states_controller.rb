class LedStatesController < ApplicationController
  before_action :set_led_state, only: [:show, :edit, :update, :destroy]

  def index
    @led_states = LedState.all
  end

  def new
    @led_state = LedState.new
  end

  def create
    @led_state = LedState.new(led_state_params)

    respond_to do |format|
      if @led_state.save
        format.html { redirect_to @led_state, notice: 'LED配置新建成功' }
        format.json { render :show, status: :created, location: @led_state }
      else
        format.html { render :new }
        format.json { render json: @led_state.errors, status: :unprocessable_entity }
      end
    end
  end

  def show

  end

  def update
    respond_to do |format|
      if @led_state.update(led_state_params)
        format.html { redirect_to @led_state, notice: 'Led State was successfully updated.' }
        format.json { render :show, status: :ok, location: @led_state }
      else
        format.html { render :edit }
        format.json { render json: @led_state.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @led_state.destroy
    respond_to do |format|
      format.html { redirect_to led_states_url, notice: 'LED STATE was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def edit
  end

  private
  def set_led_state
    @led_state = LedState.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def led_state_params
    params.require(:led_state).permit(:state,:rgb,:led_code)
  end
end
