class PermissionGroupsController < ApplicationController
  before_action :set_permission_group, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @permission_groups = PermissionGroup.all.paginate(:page => params[:page])
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

  def permission_details
    @permissions=[]
    if permission_group=PermissionGroup.find_by_id(params[:permission_groups_id])
      permission_group.permissions.each do |p|
        @permissions<<p.description
      end
    end

    render :json => @permissions
  end

  def add_permissions
    if request.post?
      p_ids=[]
      params[:permission_data].each do |p|
        if p.last[:status]=='true'
          p_ids<<p.last[:id].to_i
        end
      end

      @permission_group=PermissionGroup.find_by_id(params[:permission_group_id])
      @permission_group.manage_permissions(p_ids)
      @permissions=@permission_group.permission_details

      render :add_permissions
    else
      @permission_group=PermissionGroup.find_by_id(params["format"])
      @permissions=@permission_group.permission_details
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
