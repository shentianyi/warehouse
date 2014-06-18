class ForkliftsController < ApplicationController
  load_and_authorize_resource
  before_action :set_forklift, only: [:show, :edit, :update, :destroy]

  # GET /forklifts
  # GET /forklifts.json
  def index
    @forklifts = Forklift.all
  end

  # GET /forklifts/1
  # GET /forklifts/1.json
  def show
  end

  # GET /forklifts/new
  def new
    @forklift = Forklift.new
  end

  # GET /forklifts/1/edit
  def edit
  end

  # POST /forklifts
  # POST /forklifts.json
  def create
    @forklift = Forklift.new(forklift_params)

    respond_to do |format|
      if @forklift.save
        format.html { redirect_to @forklift, notice: 'Forklift was successfully created.' }
        format.json { render :show, status: :created, location: @forklift }
      else
        format.html { render :new }
        format.json { render json: @forklift.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /forklifts/1
  # PATCH/PUT /forklifts/1.json
  def update
    respond_to do |format|
      if @forklift.update(forklift_params)
        format.html { redirect_to @forklift, notice: 'Forklift was successfully updated.' }
        format.json { render :show, status: :ok, location: @forklift }
      else
        format.html { render :edit }
        format.json { render json: @forklift.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /forklifts/1
  # DELETE /forklifts/1.json
  def destroy
    @forklift.destroy
    respond_to do |format|
      format.html { redirect_to forklifts_url, notice: 'Forklift was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_forklift
      @forklift = Forklift.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def forklift_params
      #params[:forklift]
      params.require(:forklift).permit(:)
    end
end
