class TenantsController < ApplicationController
  before_action :set_tenant, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @tenants = Tenant.clients
    respond_with(@tenants)
  end

  def show
    respond_with(@tenant)
  end

  def new
    @tenant = Tenant.new
    respond_with(@tenant)
  end

  def edit
  end

  def create
    @tenant = Tenant.new(tenant_params)
    @tenant.save
    respond_with(@tenant)
  end

  def update
    @tenant.update(tenant_params)
    respond_with(@tenant)
  end

  def destroy
    @tenant.destroy
    respond_with(@tenant)
  end

  private
    def set_tenant
      @tenant = Tenant.find(params[:id])
    end

    def tenant_params
      params.require(:tenant).permit(:name, :code, :address, :email, :tel, :website, :type)
    end
end
