class OperationLogsController < ApplicationController
  before_action :set_operation_log, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @operation_logs = OperationLog.all.paginate(:page => params[:page]).order(created_at: :desc)
    respond_with(@operation_logs)
  end

  def show
    respond_with(@operation_log)
  end

  def new
    @operation_log = OperationLog.new
    respond_with(@operation_log)
  end

  def edit
  end

  def create
    @operation_log = OperationLog.new(operation_log_params)
    @operation_log.save
    respond_with(@operation_log)
  end

  def update
    @operation_log.update(operation_log_params)
    respond_with(@operation_log)
  end

  def destroy
    @operation_log.destroy
    respond_with(@operation_log)
  end

  private
    def set_operation_log
      @operation_log = OperationLog.find(params[:id])
    end

    def operation_log_params
      params.require(:operation_log).permit(:item_type, :item_id, :event, :whodunnit, :object)
    end
end
