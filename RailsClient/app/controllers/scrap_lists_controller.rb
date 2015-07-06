class ScrapListsController < ApplicationController
  before_action :set_scrap_list, only: [:show, :edit, :update, :destroy, :scrap]

  respond_to :html

  def index
    @scrap_lists = ScrapList.all.paginate(:page => params[:page])
    respond_with(@scrap_lists)
  end

  def show
    @scrap_list_items = ScrapListItem.where(scrap_list_id: @scrap_list.id).all
    respond_with(@scrap_list)
  end

  def new
    @scrap_list = ScrapList.new
    respond_with(@scrap_list)
  end

  def edit
  end

  def create
    builder = User.where(name: params[:scrap_list][:builder]).first
    if builder.nil?
      redirect_to new_scrap_list_path, notice: "该员工不存在！"
      return
    end

    if params[:scrap_list][:src_warehouse] == "" || params[:scrap_list][:dse_warehouse] == ""
      redirect_to new_scrap_list_path, notice: "源仓库和目的仓库不能为空！"
    else
      @scrap_list = ScrapList.new(scrap_list_params)
      if @scrap_list.save
        session[:scrap_list_id]=@scrap_list.id
        render 'scrap_list_items/new', location: @scrap_list_items
      else
      end
    end

  end

  def update
    @scrap_list.update(scrap_list_params)
    respond_with(@scrap_list)
  end

  def destroy
    @scrap_list.destroy
    respond_with(@scrap_list)
  end

  def scrap_list_items

  end

  def import
  end

  def reports
    @date_start = params[:date_start].nil? ? 1.day.ago.strftime("%Y-%m-%d 7:00") : params[:date_start]
    @date_end = params[:date_end].nil? ? Time.now.strftime("%Y-%m-%d 7:00") : params[:date_end]
    @title = ''

    @movements = Movement.generate_report_data(@date_start, @date_end)
    @title = ScrapListsHelper.gen_title(@date_start, @date_end)
    respond_to do |format|
      format.xlsx do
        send_data(entry_with_xlsx(@movements),
                  :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet",
                  :filename => "#{@title}.xlsx")
      end
      format.html
    end
  end

  def entry_with_xlsx movements
    p = Axlsx::Package.new
    wb = p.workbook
    wb.add_worksheet(:name => "Basic Sheet") do |sheet|
      sheet.add_row entry_header
      movements.each_with_index { |m, index|
        sheet.add_row [
                          index+1,
                          m.partNr,
                          m.src_qty,
                          m.dse_qty,
                          (m.src_qty - m.dse_qty)
                      ], :types => [:string]
      }
    end
    p.to_stream.read
  end

  def entry_header
    ["编号", "零件号", "源数量", "报废数量", "实际使用量"]
  end


  def scrap
    msg=Message.new
    ScrapListItem.transaction do
      @scrap_list.scrap_list_items.where(state:ScrapListItemState::UNHANDLED).each do |item|
        item.scrap
      end
      msg.result =true
    end

    respond_to do |format|
      if  msg.result
        format.html { redirect_to @scrap_list, notice: '报废成功' }
        format.json { render :show, status: :ok, location: @scrap_list }
      else
        format.html { redirect_to @scrap_list, notice: msg.content }
        format.json { render json: @scrap_list.errors, status: :unprocessable_entity }
      end
    end  end

  private
  def set_scrap_list
    @scrap_list = ScrapList.find(params[:id])
  end

  def scrap_list_params
    params.require(:scrap_list).permit(:name,:src_warehouse, :dse_warehouse, :builder)
  end
end
