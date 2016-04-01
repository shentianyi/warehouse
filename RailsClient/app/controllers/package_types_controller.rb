class PackageTypesController < ApplicationController
  before_action :set_package_type, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @package_types = PackageType.all
    respond_with(@package_types)
  end

  def show
    respond_with(@package_type)
  end

  def new
    @package_type = PackageType.new
    respond_with(@package_type)
  end

  def edit
  end

  def create
    @package_type = PackageType.new(package_type_params)
    @package_type.save
    respond_with(@package_type)
  end

  def update
    @package_type.update(package_type_params)
    respond_with(@package_type)
  end

  def destroy
    @package_type.destroy
    respond_with(@package_type)
  end

  private
    def set_package_type
      @package_type = PackageType.find(params[:id])
    end

    def package_type_params
      params.require(:package_type).permit(:nr, :name)
    end
end
