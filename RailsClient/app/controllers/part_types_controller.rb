class PartTypesController < ApplicationController
  before_action :set_part_type, only: [:show, :edit, :update, :destroy]

  # GET /part_types
  # GET /part_types.json
  def index
    @part_types = PartType.paginate(:page => params[:page])
  end

  # GET /part_types/1
  # GET /part_types/1.json
  def show
  end

  # GET /part_types/new
  def new
    @part_type = PartType.new
  end

  # GET /part_types/1/edit
  def edit
  end

  # POST /part_types
  # POST /part_types.json
  def create
    @part_type = PartType.new(part_type_params)

    respond_to do |format|
      if @part_type.save
        format.html { redirect_to part_types_path, notice: '零件类型新建成功' }
        format.json { render :show, status: :created, location: @part_type }
      else
        format.html { render :new }
        format.json { render json: @part_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /part_types/1
  # PATCH/PUT /part_types/1.json
  def update
    respond_to do |format|
      if @part_type && @part_type.update(part_type_params)
        format.html { redirect_to part_types_path, notice: '零件类型修改成功' }
        format.json { render :show, status: :ok, location: @part_type }
      else
        format.html { render :edit }
        format.json { render json: @part_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /part_types/1
  # DELETE /part_types/1.json
  def destroy
    if @part_type.parts.size==0
    @part_type.destroy
    respond_to do |format|
      format.html { redirect_to part_types_url, notice: 'Part type was successfully destroyed.' }
      format.json { head :no_content }
    end
    else
      respond_to do |format|
        format.html { redirect_to part_types_url, notice: '存在此类型的零件,不可删除' }
        format.json { head :no_content }
      end
      end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_part_type
      @part_type = PartType.find_by_id(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def part_type_params
      params.require(:part_type).permit(:id,:name)
    end
end
