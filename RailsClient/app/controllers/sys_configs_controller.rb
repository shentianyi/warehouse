class SysConfigsController < ApplicationController
  before_action :set_sys_config, only: [:show, :edit, :update, :destroy]

  # GET /sys_configs
  # GET /sys_configs.json
  def index
    @sys_config_groups = SysConfig.group(:category).order(:index)
  end

  # GET /sys_configs/1
  # GET /sys_configs/1.json
  def show
  end

  # GET /sys_configs/new
  def new
    @sys_config = SysConfig.new
  end

  # GET /sys_configs/1/edit
  def edit
  end

  # POST /sys_configs
  # POST /sys_configs.json
  def create
    @sys_config = SysConfig.new(sys_config_params)

    respond_to do |format|
      if @sys_config.save
        format.html { redirect_to sys_configs_url, notice: 'Sys config was successfully created.' }
        format.json { render :show, status: :created, location: @sys_config }
      else
        format.html { render :new }
        format.json { render json: @sys_config.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sys_configs/1
  # PATCH/PUT /sys_configs/1.json
  def update
    respond_to do |format|
      if @sys_config.update(sys_config_params)
        format.html { redirect_to sys_configs_url, notice: 'Sys config was successfully updated.' }
        format.json { render :show, status: :ok, location: @sys_config }
      else
        format.html { render :edit }
        format.json { render json: @sys_config.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sys_configs/1
  # DELETE /sys_configs/1.json
  def destroy
    @sys_config.destroy
    respond_to do |format|
      format.html { redirect_to sys_configs_url, notice: 'Sys config was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def jiaxuan_extra
    @all_locations=[]
    @all_customs=[]
    @locations=[]
    @customs=[]

    Location.all.each do |l|
      @all_locations<<{id: l.id, name: l.name}
    end

    Tenant.clients.each do |t|
      @all_customs<<{id: t.id, name: t.name}
    end

    if request.post?
      p params

      @locations=SysConfig.jiaxuan_extra_location_update(params[:location_config])
      # params[:location_config].each do |lc|
      #   sc=SysConfig.find_by_code(lc.last[:location_code])
      #   l=Location.find_by_id(lc.last[:location_id])
      #   if sc && l
      #     p sc
      #     p l
      #     sc.update_attributes(value: l.nr)
      #   end
      # end

      @customs=SysConfig.jiaxuan_extra_custom_update(params[:custom_config])
      # params[:custom_config].each do |cc|
      #   sc=SysConfig.find_by_code(cc.last[:custom_code])
      #   t=Tenant.find_by_id(cc.last[:location_id])
      #   if sc && t
      #     p sc
      #     p t
      #     sc.update_attributes(value: t.code)
      #   end
      # end

    else
      @locations = SysConfig.where(category: '佳轩扩展配置', index: 1200)
      @customs = SysConfig.where(category: '佳轩扩展配置', index: 1300)
    end
    # SysConfig.where(category: '佳轩扩展配置', index: 1200).each do |sys_config|
    #   location_options=[]
    #   Location.all.each do |l|
    #     location_options<<{id: l.id, name: l.name, status: l.nr==sys_config.value}
    #   end
    #   @all_locations<<{name: sys_config.name, code: sys_config.code, options: location_options}
    # end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_sys_config
    @sys_config = SysConfig.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def sys_config_params
    params.require(:sys_config).permit(:code, :value, :name)
  end
end
