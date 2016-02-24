class PermissionGroupsController < ApplicationController
  before_action :set_permission_group, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @permission_groups = PermissionGroup.all.paginate(:page=> params[:page])
    respond_with(@permission_groups)
  end

  def show
    respond_with(@permission_group)
  end

  def new
    @permission_group = PermissionGroup.new
    respond_with(@permission_group)
  end

  def edit
  end

  def create
    @permission_group = PermissionGroup.new(permission_group_params)
    @permission_group.save
    respond_with(@permission_group)
  end

  def update
    @permission_group.update(permission_group_params)
    respond_with(@permission_group)
  end

  def destroy
    @permission_group.destroy
    respond_with(@permission_group)
  end

  def details

    p '0000000000000000000000000000000000'
  end

  def add_permissions
    if request.post?
      p @permission_group
      p "99999999999999999999999999999999999999999"
      @permissions=[]
      p params
      p params[:PermissionData]

    else
      p '1111111111111111111111111111111111111111111'
      p params
      @permissions=[]
      @permission_group=PermissionGroup.find_by_id(params["format"])
      @permission_group_items=@permission_group.permissions
      Permission.all.each do |p|
        @permissions<<{
            id: p.id,
            name: p.name,
            status: @permission_group_items.include?(p)
        }
      end
      @permissions
    end
  end

  private
    def set_permission_group
      @permission_group = PermissionGroup.find(params[:id])
    end

    def permission_group_params
      params.require(:permission_group).permit(:name, :description)
    end
end
