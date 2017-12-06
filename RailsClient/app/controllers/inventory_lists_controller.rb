class InventoryListsController < ApplicationController
  before_action :set_inventory_list, only: [:show, :edit, :update, :destroy, :inventory_list_items]

  respond_to :html

  def index

    @inventory_lists = InventoryList.paginate(:page => params[:page])

    if SysConfigCache.hide_finished_inventory_value=='true'
      @inventory_lists=@inventory_lists.where('state!=?', InventoryListState::ENDING)
    end
    respond_with(@inventory_lists)
  end

  def show
    respond_with(@inventory_list)
  end

  def new
    @inventory_list = InventoryList.new
    respond_with(@inventory_list)
  end

  def edit
  end

  def create
    @inventory_list = InventoryList.new(inventory_list_params)
    @inventory_list.user_id = current_user.id
    @inventory_list.save
    respond_to do |format|
      if @inventory_list.save
        format.html { redirect_to @inventory_list, notice: 'InventoryList was successfully created.' }
        format.json { render :show, status: :created, location: @inventory_list }
      else
        format.html { render :new }
        format.json { render json: @inventory_list.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @inventory_list.update(inventory_list_params)
    respond_with(@inventory_list)
  end

  def destroy
    @inventory_list.destroy
    respond_with(@inventory_list)
  end

  def inventory_list_items
    @inventory_list_items = @inventory_list.inventory_list_items.paginate(:page => params[:page])
    @page_start=(params[:page].nil? ? 0 : (params[:page].to_i-1))*20
  end

  def discrepancy
    @inventory_list_id = params[:sid]||params[:id]
    @inventory_list=InventoryList.find_by_id(@inventory_list_id)
    @results = @inventory_list.generate_qty_discrepancy_report

    @title="#{@inventory_list.name}-数量差异报表"
    respond_to do |format|
      format.xlsx do
        send_data(qty_discrepancy_report_xlsx(@results),
                  :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet",
                  :filename => @title+".xlsx"
        )
      end

      format.html
    end
  end

  def pack_discrepancy
    @inventory_list_id = params[:sid]||params[:id]
    @inventory_list=InventoryList.find_by_id(@inventory_list_id)
    @results = @inventory_list.generate_pack_discrepancy_report

    @title="#{@inventory_list.name}-唯一码差异报表"
    respond_to do |format|
      format.xlsx do
        send_data(pack_discrepancy_report_xlsx(@results),
                  :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet",
                  :filename => @title+".xlsx"
        )
      end

      format.html
    end
  end

  def export_total
    msg = FileHandler::Excel::InventoryListItemHandler.export_total_no_fifo(
        InventoryListItem.joins(:inventory_list).joins(:part)
            .where(inventory_lists: {state: InventoryListState::PROCESSING})
            .group('part_id').select('inventory_list_items.*,sum(qty) as qty,count(*) as num,parts.nr as part_nr')
    )
    send_file msg.content
  end

  def export_by_whouse
    msg = FileHandler::Excel::InventoryListItemHandler.export_total_by_whouse
    send_file msg.content
  end

  def disable_enable_storage
    # if request.post?=
    last_batch=0
    if storage=NStorage.unscoped.order(lock_batch: :desc).first
      last_batch=storage.lock_batch
    end
    if params[:do]=='disable'
      flash[:notice]='盘点重置成功'
      NStorage.transaction do
        lock_remark='盘点覆盖锁定'+"-"+Time.now.strftime("%Y%m%d")
        NStorage.where(locked: false)
            .update_all(locked: true,
                        lock_user_id: 'admin',
                        lock_remark: lock_remark,
                        lock_batch: last_batch+1,
                        lock_at: Time.now.utc)
      end

    else
      flash[:notice]='取消盘点重置成功'
      NStorage.transaction do
        NStorage.unscoped.where(locked: true, lock_batch: last_batch)
            .update_all(locked: false,
                        lock_user_id: nil,
                        lock_remark: nil,
                        lock_at: nil)
      end
    end
    # end

    redirect_to action: :index
  end

  private
  def set_inventory_list
    @inventory_list = InventoryList.find(params[:id])
  end

  def inventory_list_params
    params.require(:inventory_list).permit(:name, :state, :whouse_id, :user_id)
  end

  def qty_discrepancy_report_xlsx results
    p = Axlsx::Package.new
    wb = p.workbook
    wb.add_worksheet(:name => "Basic Sheet") do |sheet|
      sheet.add_row ["No.", "零件号", "库存数量", "盘点数量", "数量差异值（库存数量-盘点数量）", "库存数量", "盘点数量", "数量差异值(库存数量-盘点数量)"]
      results.each_with_index { |o, index|
        sheet.add_row [
                          index+1,
                          o[0],
                          o[1],
                          o[2],
                          o[3],
                          o[4],
                          o[5],
                          o[6]
                      ], :types => [:string]
        # removal_packages["#{o.part_id}#{o.whouse_id}"] = nil
      }
    end
    p.to_stream.read
  end


  def pack_discrepancy_report_xlsx results
    p = Axlsx::Package.new
    wb = p.workbook
    wb.add_worksheet(:name => "Basic Sheet") do |sheet|
      sheet.add_row ["No.", '唯一码', "零件号", "库存库位", "盘点库位", "库位一致"]
      i=0
      results.each { |k, v|
        sheet.add_row [
                          i+=1,
                          v[:package_id],
                          v[:part_nr],
                          v[:stock_position_nr],
                          v[:inven_position_nr],
                          InventoryList.bool_display(v[:same_position])
                      ], :types => [:string,:string,:string,:string,:string,:string]
        # removal_packages["#{o.part_id}#{o.whouse_id}"] = nil
      }
    end
    p.to_stream.read
  end


end
