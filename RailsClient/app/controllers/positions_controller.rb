class PositionsController < ApplicationController
  #load_and_authorize_resource
  before_action :set_position, only: [:show, :edit, :update, :destroy, :parts]

  # GET /positions
  # GET /positions.json
  def index
    @positions = Position.order(nr: :asc).paginate(:page=>params[:page])#all
    #@positions = @positions.paginate(:page=>params[:page])
  end

  # GET /positions/1
  # GET /positions/1.json
  def show
  end

  # GET /positions/new
  def new
    @position = Position.new
  end

  # GET /positions/1/edit
  def edit
  end

  # POST /positions
  # POST /positions.json
  def create
    @position = Position.new(position_params)

    respond_to do |format|
      if @position.save
        format.html { redirect_to @position, notice: 'Position was successfully created.' }
        format.json { render :show, status: :created, location: @position }
      else
        format.html { render :new }
        format.json { render json: @position.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /positions/1
  # PATCH/PUT /positions/1.json
  def update
    respond_to do |format|
      if @position.update(position_params)
        format.html { redirect_to @position, notice: 'Position was successfully updated.' }
        format.json { render :show, status: :ok, location: @position }
      else
        format.html { render :edit }
        format.json { render json: @position.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /positions/1
  # DELETE /positions/1.json
  def destroy
    if @position.is_default
      respond_to do |format|
        format.html { redirect_to positions_url, notice: '默认库位不可以删除.' }
        format.json { head :no_content }
      end
    else
      @position.destroy
      respond_to do |format|
        format.html { redirect_to positions_url, notice: 'Position was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  end

  # GET /positions/users
  def parts
    @parts = @position.parts.paginate(:page=>params[:page])
  end

  def search
    super { |query|
      if whouse=Whouse.find_by_nr(params[:position][:whouse_id])
        query=query.unscope(where: :whouse_id).where(whouse_id: whouse.id)
      end

      query
    }
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_position
      @position = Position.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def position_params
      #params[:position]
      params.require(:position).permit(:id,:detail,:whouse_id,:nr)
    end
end
