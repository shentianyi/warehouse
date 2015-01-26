class PackagesController < ApplicationController
  #load_and_authorize_resource
  before_action :set_package, only: [:show, :edit, :update, :destroy]

  # GET /packages
  # GET /packages.json
  def index
    @packages = PackageService.search(nil).order(created_at: :desc).paginate(:page => params[:page]) #all
    #@packages = @packages.paginate(:page=>params[:page])
  end

  # GET /packages/1
  # GET /packages/1.json
  def show
  end

  # GET /packages/new
  def new
    @package = Package.new
  end

  # GET /packages/1/edit
  def edit
  end

  # POST /packages
  # POST /packages.json
=begin
  def create
    @package = Package.new(package_params)

    respond_to do |format|
      if @package.save
        format.html { redirect_to @package, notice: 'Package was successfully created.' }
        format.json { render :show, status: :created, location: @package }
      else
        format.html { render :new }
        format.json { render json: @package.errors, status: :unprocessable_entity }
      end
    end
  end
=end

  # PATCH/PUT /packages/1
  # PATCH/PUT /packages/1.json
  def update
    respond_to do |format|
      if @package.update(package_params)
        format.html { redirect_to package_url(@package), notice: '包装箱修改成功.' }
        format.json { render :show, status: :ok, location: @package }
      else
        format.html { render :edit }
        format.json { render json: @package.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /packages/1
  # DELETE /packages/1.json
  def destroy
    @package.destroy
    respond_to do |format|
      format.html { redirect_to packages_url, notice: 'Package was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_package
    @package = PackageService.search(id:params[:id]).first
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def package_params
    #params[:package]
    params.require(:logistics_container).permit(:state,:remark)
  end

=begin
  def set_search_variable
    p= params[:package]
    @id=p[:id]
    @stocker_id=p[:user]
    @state=p[:state]
    @created_at_start=p[:created_at][:start]
    @created_at_end=p[:created_at][:end]
  end
=end
end
