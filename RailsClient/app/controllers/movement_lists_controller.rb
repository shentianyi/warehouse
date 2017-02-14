class MovementListsController < ApplicationController
  before_action :set_movement_list, only: [:show, :edit, :update, :destroy, :movement_sources]

  respond_to :html

  def index
    @movement_lists = MovementList.all.paginate(:page => params[:page])
    respond_with(@movement_lists)
  end

  def show
    respond_with(@movement_list)
  end

  def new
    @movement_list = MovementList.new
    respond_with(@movement_list)
  end

  def edit
  end

  def create
    @movement_list = MovementList.new(movement_list_params)
    @movement_list.save
    respond_with(@movement_list)
  end

  def update
    @movement_list.update(movement_list_params)
    respond_with(@movement_list)
  end

  def destroy
    @movement_list.destroy
    respond_with(@movement_list)
  end


  def movement_sources
    @movement_sources = @movement_list.movement_sources.paginate(:page => params[:page])
    @page_start=(params[:page].nil? ? 0 : (params[:page].to_i-1))*20
  end

  def exports
    @movement_sources = MovementList.find(params[:format]).movement_sources

    send_data(entry_with_xlsx(@movement_sources),
              :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet",
              :filename => "#{MovementList.find(params[:format]).name}.xlsx")
  end

  def entry_with_xlsx movement_sources
    p = Axlsx::Package.new
    wb = p.workbook
    wb.add_worksheet(:name => "Basic Sheet") do |sheet|
      sheet.add_row entry_header
      movement_sources.each_with_index { |m, index|
        fromWh=Whouse.find_by_id(m.fromWh)
        fromPosition=Position.find_by_id(m.fromPosition)
        toWh=Whouse.find_by_id(m.toWh)
        toPosition=Position.find_by_id(m.toPosition)
        partNr=Part.find_by_id(m.partNr)
        employee=User.find_by_id(m.employee_id)
        sheet.add_row [
                          index+1,
                          m.movement_list_id,

                          (fromWh.blank? ? '' : fromWh.name),
                          (fromPosition.blank? ? '' : fromPosition.nr),
                          (toWh.blank? ? '' : toWh.name),
                          (toPosition.blank? ? '' : toPosition.nr),
                          m.packageId,

                          (partNr.blank? ? '' : partNr.nr),
                          m.qty,
                          m.fifo,
                          (employee.blank? ? '' : employee.nr),
                          m.remarks
                      ], :types => [:string]
      }
    end
    p.to_stream.read
  end

  def entry_header
    ["编号", "移库单号", "源仓库", "源库位", "目的仓库", "目的库位", "唯一码", "零件号", "数量", "FIFO", "员工号", "备注"]
  end

  private
    def set_movement_list
      @movement_list = MovementList.find(params[:id])
    end

    def movement_list_params
      params.require(:movement_list).permit(:uuid, :name, :state, :builder, :remarks)
    end
end
