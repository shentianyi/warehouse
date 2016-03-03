class PartClientsController < ApplicationController
  before_action :set_part_client, only: [:edit, :update, :destroy]

  before_action :set_tenant, only: [:index, :new, :edit,:destroy]
  before_action :set_part_clients, only: [:index]
  before_action :prepare_tenant_client_part_params, only: [:create, :update]

  respond_to :html

  def index
    respond_with(@part_clients)
  end

  def show
    respond_with(@part_client)
  end

  def new
    @part_client = PartClient.new
    respond_with(@part_client)
  end

  def edit
  end

  def create
    if @part_client.errors.blank? && @part_client.save
      redirect_to tenant_part_clients_path(@tenant)
    else
      redirect_to new_tenant_part_client_path({tenant_id: @tenant.id, part_client: @part_client}), notice: @part_client.errors.messages.values.join(',')
    end
  end

  def update
    p @part_client
    if @part_client.errors.blank? && @part_client.save
      redirect_to tenant_part_clients_path(@tenant)
    else
      redirect_to edit_tenant_part_client_path({tenant_id: @tenant.id, id: @part_client.id}), notice: @part_client.errors.messages.values.join(',')
    end
    #respond_with(@part_client)
  end

  def destroy
    @part_client.destroy
    redirect_to  tenant_part_clients_path(@tenant),notice: '删除成功'
    #respond_with(@part_client)
  end



  def import
    if request.post?
      msg = Message.new
      begin
        file=params[:files][0]
        fd = FileData.new(data: file, oriName: file.original_filename,
                          path: $tmp_file_path,
                          pathName: "#{Time.now.strftime('%Y%m%d%H%M%S%L')}~#{file.original_filename}")
        fd.save
        msg = FileHandler::Excel::PartClientHandler.import(fd,params[:tenant_id])
      rescue => e
        msg.content = e.message
      end
      render json: msg
    end
  end
  private
  def set_tenant
    unless @tenant=Tenant.find_by_id(params[:tenant_id])
      redirect_to tenants_path, notice: 'Please select a Client'
    end
  end

  def set_part_clients
    @part_clients=@tenant.parts.paginate(:page=>params[:page])
  end

  def set_part_client
    @part_client = PartClient.find(params[:id])
  end

  def prepare_tenant_client_part_params
    @tenant=Tenant.find_by_id(params[:part_client][:client_tenant_id])
    mp = part_client_params

    if action_name=='create'
      @part_client=PartClient.new(mp)
      mp.keys.each { |k|
        flash[k]=mp[k]
      }
    elsif action_name=='update'
      @part_client.client_part_nr= params[:part_client][:client_part_nr]
    end

    if params[:part_client][:part_id].present? && (part=Part.find_by_nr(params[:part_client][:part_id]))
      @part_client.part_id=part.id
    else
      @part_client.errors.add(:part_id, '零件号不存在')
    end
  end

  def part_client_params
    params.require(:part_client).permit(:part_id, :client_part_nr, :client_tenant_id)
  end
end
