# -*- coding: utf-8 -*-
class PermissionsController < ApplicationController
  before_action :set_permission, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @permissions = Permission.all.paginate(:page=> params[:page])
    respond_with(@permissions)
  end

  def show
    respond_with(@permission)
  end

  def new
    @permission = Permission.new
    respond_with(@permission)
  end

  def edit
  end

  def create
    @permission = Permission.new(permission_params)
    @permission.save
    respond_with(@permission)
  end

  def update
    @permission.update(permission_params)
    respond_with(@permission)
  end

  def destroy
    @permission.destroy
    respond_with(@permission)
  end

  private
    def set_permission
      @permission = Permission.find(params[:id])
    end

    def permission_params
      params.require(:permission).permit(:name, :description)
    end
end
