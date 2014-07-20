class PickListsController < ApplicationController
  before_action :set_pick_list, only: [:show, :edit, :update, :destroy]

  # GET /pick_lists
  # GET /pick_lists.json
  def index
    @pick_lists = PickList.all
  end

  # GET /pick_lists/1
  # GET /pick_lists/1.json
  def show
  end

  # GET /pick_lists/new
  def new
    @pick_list = PickList.new
  end

  # GET /pick_lists/1/edit
  def edit
  end

  # POST /pick_lists
  # POST /pick_lists.json
  def create
    @pick_list = PickList.new(pick_list_params)

    respond_to do |format|
      if @pick_list.save
        format.html { redirect_to @pick_list, notice: 'Pick list was successfully created.' }
        format.json { render :show, status: :created, location: @pick_list }
      else
        format.html { render :new }
        format.json { render json: @pick_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pick_lists/1
  # PATCH/PUT /pick_lists/1.json
  def update
    respond_to do |format|
      if @pick_list.update(pick_list_params)
        format.html { redirect_to @pick_list, notice: 'Pick list was successfully updated.' }
        format.json { render :show, status: :ok, location: @pick_list }
      else
        format.html { render :edit }
        format.json { render json: @pick_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pick_lists/1
  # DELETE /pick_lists/1.json
  def destroy
    @pick_list.destroy
    respond_to do |format|
      format.html { redirect_to pick_lists_url, notice: 'Pick list was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pick_list
      @pick_list = PickList.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pick_list_params
      params.require(:pick_list).permit(:id, :user_id)
    end
end
