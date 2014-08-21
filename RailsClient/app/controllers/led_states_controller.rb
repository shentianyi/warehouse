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

  end

  def destroy

  end

  private
  def set_led_state
    @led_State = LedState.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def led_state_params
    params.require(:led_state).permit(:name,:rgb,:led_code)
  end
end
