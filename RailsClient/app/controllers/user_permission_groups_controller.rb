class UserPermissionGroupsController < ApplicationController
  before_action :set_user_permission_group, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @user_permission_groups = UserPermissionGroup.all
    respond_with(@user_permission_groups)
  end

  def show
    respond_with(@user_permission_group)
  end

  def new
    @user_permission_group = UserPermissionGroup.new
    respond_with(@user_permission_group)
  end

  def edit
  end

  def create
    @user_permission_group = UserPermissionGroup.new(user_permission_group_params)
    @user_permission_group.save
    respond_with(@user_permission_group)
  end

  def update
    @user_permission_group.update(user_permission_group_params)
    respond_with(@user_permission_group)
  end

  def destroy
    @user_permission_group.destroy
    respond_with(@user_permission_group)
  end

  private
    def set_user_permission_group
      @user_permission_group = UserPermissionGroup.find(params[:id])
    end

    def user_permission_group_params
      params.require(:user_permission_group).permit(:user_id, :permission_group_id)
    end
end
