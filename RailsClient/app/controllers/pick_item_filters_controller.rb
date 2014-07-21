class PickItemFiltersController < ApplicationController
  before_action :set_pick_item_filter, only: [:show, :edit, :update, :destroy]
  before_action :set_condition,only:[:index,:new,:edit,:search]
  # GET /pick_item_filters
  # GET /pick_item_filters.json
  def index
    @pick_item_filters = PickItemFilter.order(:user_id).paginate(:page=>params[:page])
  end

  # GET /pick_item_filters/1
  # GET /pick_item_filters/1.json
  def show
  end

  # GET /pick_item_filters/new
  def new
    @pick_item_filter = PickItemFilter.new
  end

  # GET /pick_item_filters/1/edit
  def edit
  end

  # POST /pick_item_filters
  # POST /pick_item_filters.json
  def create
    @pick_item_filter = PickItemFilter.new(pick_item_filter_params)
    respond_to do |format|
      if @pick_item_filter.save
        format.html { redirect_to pick_item_filters_url, notice: '新建成功.' }
        format.json { render :show, status: :created, location: @pick_item_filter }
      else
        format.html { render :new }
        format.json { render json: @pick_item_filter.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pick_item_filters/1
  # PATCH/PUT /pick_item_filters/1.json
  def update
    respond_to do |format|
      if @pick_item_filter.update(pick_item_filter_params)
        format.html { redirect_to pick_item_filters_url, notice: '更新成功.' }
        format.json { render :show, status: :ok, location: @pick_item_filter }
      else
        format.html { render :edit }
        format.json { render json: @pick_item_filter.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pick_item_filters/1
  # DELETE /pick_item_filters/1.json
  def destroy
    @pick_item_filter.destroy
    respond_to do |format|
      format.html { redirect_to pick_item_filters_url, notice: '删除成功.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pick_item_filter
      @pick_item_filter = PickItemFilter.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pick_item_filter_params
      params.require(:pick_item_filter).permit( :user_id, :filterable_id, :filterable_type)
    end


  def set_condition
    @types= PickItemFilter.filter_types.values.collect{|v| [v[:display],v[:name]]}
  end
end
