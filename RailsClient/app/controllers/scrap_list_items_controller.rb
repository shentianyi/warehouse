class ScrapListItemsController < ApplicationController
  before_action :set_scrap_list_item, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @scrap_list_items = ScrapListItem.all.paginate(:page => params[:page])
    respond_with(@scrap_list_items)
  end

  def show
    respond_with(@scrap_list_item)
  end

  def new
    # @scrap_list_item = ScrapListItem.new
    # respond_with(@scrap_list_item)
    @scrap_list=ScrapList.find_by_id(params[:id])
    session[:scrap_list_id]=params[:id]
  end

  def edit
  end

  def create
    @scrap_list_item = ScrapListItem.new(scrap_list_item_params)
    @scrap_list_item.save
    respond_with(@scrap_list_item)
  end

  def update
    respond_to do |format|
      if @scrap_list_item.update(scrap_list_item_params)
        format.html { redirect_to @scrap_list_item, notice: 'successfully updated.' }
        format.json { render :show, status: :ok, location: @scrap_list_item }
      else
        format.html { render :edit }
        format.json { render json: @scrap_list_item.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @scrap_list_item.destroy
    respond_with(@scrap_list_item)
  end

  def import
    if request.post?
      msg = Message.new
      begin
        file=params[:files][0]
        fd = FileData.new(data: file, oriName: file.original_filename, path: $tmp_file_path, pathName: "#{Time.now.strftime('%Y%m%d%H%M%S%L')}~#{file.original_filename}")
        fd.save
        msg = FileHandler::Excel::ScrapListItemHandler.import(fd,session[:scrap_list_id])
      rescue => e
        msg.content = e.message
      end
      render json: msg
    end
  end

  def search
    @date_start = params[:date_start].nil? ? 1.day.ago.strftime("%Y-%m-%d 7:00") : params[:date_start]
    @date_end = params[:date_end].nil? ? Time.now.strftime("%Y-%m-%d 7:00") : params[:date_end]
    @src_warehouse = params[:src_warehouse] if params[:src_warehouse].present?
    @dse_warehouse = params[:dse_warehouse] if params[:dse_warehouse].present?

    respond_to do |format|
      format.xlsx do
        @scrap_list_items = ScrapListItem.generate_report_data(@date_start, @date_end, @src_warehouse, @dse_warehouse)
        send_data(entry_with_xlsx(@scrap_list_items),
                  :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet",
                  :filename => "报废查询导出.xlsx")
      end
      format.html do
        @scrap_list_items = ScrapListItem.generate_report_data(@date_start, @date_end, @src_warehouse, @dse_warehouse).paginate(:page => params[:page])
        render :index
      end
    end
  end

  def scrap_list_item_header_detials
    ["编号", "报废单号", "源仓库号","目的仓库号", "零件号", "总成号", "数量", "单位", "原因", "登记人", "状态", "登记时间"]
  end

  def entry_with_xlsx items
    p = Axlsx::Package.new
    wb = p.workbook
    wb.add_worksheet(:name => "Basic Sheet") do |sheet|


      sheet.add_row scrap_list_item_header_detials
      items.each_with_index { |item, index|

        src_warehouse = ScrapList.find(item.scrap_list_id).src_warehouse
        dse_warehouse = ScrapList.find(item.scrap_list_id).dse_warehouse

        sheet.add_row [
                          index+1,
                          item.scrap_list_id,
                          src_warehouse,
                          dse_warehouse,
                          item.part_id,
                          item.product_id,
                          item.quantity,
                          item.IU,
                          item.reason,
                          item.name,
                          ScrapListItemState.display(item.state),
                          item.time
                      ], :types => [:string]
      }

    end
    p.to_stream.read
  end

  private
    def set_scrap_list_item
      @scrap_list_item = ScrapListItem.find(params[:id])
    end

    def scrap_list_item_params
      params.require(:scrap_list_item).permit(:scrap_list_id, :part_id, :product_id, :quantity, :IU, :reason, :name, :time,:state)
    end
end
