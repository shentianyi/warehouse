class FortliftsController < ApplicationController
  load_and_authorize_resource
  before_action :set_fortlift, only: [:show, :edit, :update, :destroy]

  # GET /fortlifts
  # GET /fortlifts.json
  def index
    @fortlifts = Fortlift.all
  end

  # GET /fortlifts/1
  # GET /fortlifts/1.json
  def show
  end

  # GET /fortlifts/new
  def new
    @fortlift = Fortlift.new
  end

  # GET /fortlifts/1/edit
  def edit
  end

  # POST /fortlifts
  # POST /fortlifts.json
  def create
    @fortlift = Fortlift.new(fortlift_params)

    respond_to do |format|
      if @fortlift.save
        format.html { redirect_to @fortlift, notice: 'Fortlift was successfully created.' }
        format.json { render :show, status: :created, location: @fortlift }
      else
        format.html { render :new }
        format.json { render json: @fortlift.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /fortlifts/1
  # PATCH/PUT /fortlifts/1.json
  def update
    respond_to do |format|
      if @fortlift.update(fortlift_params)
        format.html { redirect_to @fortlift, notice: 'Fortlift was successfully updated.' }
        format.json { render :show, status: :ok, location: @fortlift }
      else
        format.html { render :edit }
        format.json { render json: @fortlift.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fortlifts/1
  # DELETE /fortlifts/1.json
  def destroy
    @fortlift.destroy
    respond_to do |format|
      format.html { redirect_to fortlifts_url, notice: 'Fortlift was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fortlift
      @fortlift = Fortlift.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def fortlift_params
      params[:fortlift]
    end
end
