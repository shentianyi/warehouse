class ModemsController < ApplicationController
  before_action :set_modem, only: [:show, :edit, :update, :destroy]

  # GET /modems
  # GET /modems.json
  def index
    @modems =  Modem.paginate(:page=> params[:page])
  end

  # GET /modems/1
  # GET /modems/1.json
  def show
  end

  # GET /modems/new
  def new
    @modem = Modem.new
  end

  # GET /modems/1/edit
  def edit
  end

  # POST /modems
  # POST /modems.json
  def create
    @modem = Modem.new(modem_params)

    respond_to do |format|
      if @modem.save
        format.html { redirect_to @modem, notice: 'Modem was successfully created.' }
        format.json { render :show, status: :created, location: @modem }
      else
        format.html { render :new }
        format.json { render json: @modem.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /modems/1
  # PATCH/PUT /modems/1.json
  def update
    respond_to do |format|
      if @modem.update(modem_params)
        format.html { redirect_to @modem, notice: 'Modem was successfully updated.' }
        format.json { render :show, status: :ok, location: @modem }
      else
        format.html { render :edit }
        format.json { render json: @modem.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /modems/1
  # DELETE /modems/1.json
  def destroy
    @modem.destroy
    respond_to do |format|
      format.html { redirect_to modems_url, notice: 'Modem was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_modem
      @modem = Modem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def modem_params
      params.require(:modem).permit(:id, :name, :ip, :nr)
    end
end
