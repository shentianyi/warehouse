class StorageOperationRecordsController < ApplicationController
  before_action :set_storage_operation_record, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @storage_operation_records = StorageOperationRecord.all.paginate(:page => params[:page]).order(created_at: :desc)
    respond_with(@storage_operation_records)
  end

  def show
    respond_with(@storage_operation_record)
  end

  def new
    @storage_operation_record = StorageOperationRecord.new
    respond_with(@storage_operation_record)
  end

  def edit
  end

  def create
    @storage_operation_record = StorageOperationRecord.new(storage_operation_record_params)
    @storage_operation_record.save
    respond_with(@storage_operation_record)
  end

  def update
    @storage_operation_record.update(storage_operation_record_params)
    respond_with(@storage_operation_record)
  end

  def destroy
    @storage_operation_record.destroy
    respond_with(@storage_operation_record)
  end

  private
    def set_storage_operation_record
      @storage_operation_record = StorageOperationRecord.find(params[:id])
    end

    def storage_operation_record_params
      params.require(:storage_operation_record).permit(:partNr, :qty, :fromWh, :fromPosition, :toWh, :toPosition, :packageId, :type_id, :remarks, :employee_id, :fifo)
    end
end
