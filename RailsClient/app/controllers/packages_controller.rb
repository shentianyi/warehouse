class PackagesController < ApplicationController
  #load_and_authorize_resource
  before_action :set_package, only: [:show, :edit, :update, :destroy]

  # GET /packages
  # GET /packages.json
  def index
    @packages = PackageService.search(nil,true,current_user.location).order(created_at: :desc).paginate(:page => params[:page]) #all
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

  # def search
  #   super { |query|

  #   }
  # end

  def import
    if request.post?
      msg = Message.new
      begin
        file=params[:files][0]
        fd = FileData.new(data: file, oriName: file.original_filename, path: $tmp_file_path, pathName: "#{Time.now.strftime('%Y%m%d%H%M%S%L')}~#{file.original_filename}")
        fd.save
        msg = FileHandler::Excel::PackageHandler.import(fd, current_user)
      rescue => e
        msg.content = e.message
      end
      render json: msg
    end
  end

  def download_quantity
    file_name= 'packages_quantities_'+Time.now.strftime('%Y%m%d%H%M%S')+'.csv'
    path=File.join($DOWNLOADPATH, file_name)
    msg = Message.new
    msg.result = false
    begin
      File.open(path, 'wb') do |f|
        f.puts ['Part', 'Quantity'].join($CSVSP)
        items = Package.joins(:part).select("DISTINCT parts.id,containers.quantity")
        items.each do |item|
          line = [item['id'], item['quantity']]
          f.puts line.join($CSVSP)
        end
      end
      msg.result=true
    rescue => e
      msg.content =e.message
      puts e.backtrace
      render json: msg and return
    end
    send_file path, :type => 'application/csv', :filename => file_name
  end

  # PATCH/PUT /packages/1
  # PATCH/PUT /packages/1.json
  def update
    respond_to do |format|
      if @package.update(package_params)
        @package.update(is_dirty: true)

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
    @package = PackageService.search(id: params[:id]).first
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def package_params
    #params[:package]
    params.require(:logistics_container).permit(:state, :remark)
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
