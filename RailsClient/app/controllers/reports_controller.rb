# encoding: utf-8
class ReportsController < ApplicationController
  def stockout
    @part_id = params[:part_id]
    @date_start = params[:date_start].nil? ? 1.day.ago.strftime("%Y-%m-%d 7:00") : params[:date_start]
    @date_end = params[:date_end].nil? ? Time.now.strftime("%Y-%m-%d 7:00") : params[:date_end]

    part=Part.find_by_nr(params[:part_id])
    part_id = part.blank? ? nil : part.id
    @items=OrderItem.generate_stockout_data(@date_start, @date_end, part_id, current_user)

    if (params.has_key? "send_emails") && current_user.location.is_open_safe_qty
      emails=current_user.location.safe_qty_emails.split(',')
      warning_data=OrderItem.generate_need_warning_data(@items)
      if (warning_data.count > 0) && (emails.count > 0)
        StockWarningMailer.stock_warning(emails, warning_data)
      end
    end

    respond_to do |format|
      format.xlsx do
        send_data(stockout_with_xlsx(@items),
                  :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet",
                  :filename => "缺货信息导出.xlsx")
      end
      format.html
    end
  end

  def reports
    @part_id = params[:part_id]
    @type = params[:type].nil? ? ReportType::Entry : params[:type]
    @date_start = params[:date_start].nil? ? 1.day.ago.strftime("%Y-%m-%d 7:00") : params[:date_start]
    @date_end = params[:date_end].nil? ? Time.now.strftime("%Y-%m-%d 7:00") : params[:date_end]
    @location_id = params[:location_id].nil? ? current_user.location_id : params[:location_id]
    @title = ''
    @commit_value = params[:commit]

    part=Part.find_by_nr(params[:part_id])
    part_id = part.blank? ? nil : part.id

    location=Location.find_by_nr(@location_id)
    location_id=location.blank? ? nil : location.id


    @packages = Package.generate_report_data(@type, @date_start, @date_end, @location_id, @commit_value, part_id)
    #render :json=> @packages
    @title = ReportsHelper.gen_title(@type, @date_start, @date_end, @location_id)
    respond_to do |format|
      format.xlsx do
        send_data(entry_with_xlsx(@packages, @commit_value),
                  :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet",
                  :filename => "#{@title}.xlsx")
      end
      format.html
    end
  end

  def upload_file
    msg=Message.new
    if params[:files].size==1
      path=File.join($UPDATAPATH, 'reports')
      file=params[:files][0]
      fd=FileData.new(data: file, oriName: file.original_filename, path: path, pathName: "#{Time.now.strftime('%Y%m%d%H%M%S')}-#{file.original_filename}")
      fd.saveFile
      msg.result =true
      msg.content =fd
    else
      msg.content='未选择文件或只能上传一个文件'
    end
    render json: msg
  end

  def discrepancy
    @type = params[:type].nil? ? ReportType::Entry : params[:type]
    @location_id = params[:location_id].nil? ? current_user.location_id : params[:location_id]
    @date_start = params[:received_date_start].nil? ? 1.day.ago.strftime("%Y-%m-%d 7:00") : params[:received_date_start]
    @date_end = params[:received_date_end].nil? ? Time.now.strftime("%Y-%m-%d 7:00") : params[:received_date_end]
    @title = ''

    @packages = {}

    Package.generate_report_data(@type, @date_start, @date_end, @location_id).each { |p|
      if @packages[p['part_id']+p['whouse']].nil?
        @packages[p['part_id']+p['whouse']] = {"PartNr." => p['part_id'], "Warehouse" => p['whouse'], "Amount" => 0}
      end
      @packages[p['part_id']+p['whouse']]["Amount"] = @packages[p['part_id']+p['whouse']]["Amount"] + p['count']
    }

    # ===>2014/12/08 李其：写这个是因为之前出现同步错误，现在不允许出现同步覆盖状态的问题
    #     现在不允许出现，故注释代码
=begin
    @uncounted_packages = {}
    condition["packages.state"] = [PackageState::WAY, PackageState::ORIGINAL]
    Package.entry_report(condition).each { |p|
      if @uncounted_packages[p.part_id+p.whouse_id].nil?
        @uncounted_packages[p.part_id+p.whouse_id] = {"PartNr." => p.part_id, "Warehouse" => p.whouse_id, "Amount" => 0}
      end
      @uncounted_packages[p.part_id+p.whouse_id]["Amount"] = @uncounted_packages[p.part_id+p.whouse_id]["Amount"] + p.total
    }
=end

    @results = {}
    if params.has_key?(:file)
      @file = JSON.parse(params[:file])
      case @file["extention"]
        when '.csv'
          @results = ReportsHelper.csv_filter(params[:file])
        when '.xlsx'
          @results = ReportsHelper.xlsx_filter(params[:file])
      end
    end

    @title = ReportsHelper.gen_title(@type, @date_start, @date_end, @location_id, "差异")

    respond_to do |format|
      format.html
      format.xlsx do
        send_data(entry_discrepancy_xlsx(@packages, @results),
                  :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet",
                  :filename => "#{@title}.xlsx"
        )
      end
    end
  end

  def orders_report
    @date_start = params[:date_start].nil? ? 1.day.ago.strftime("%Y-%m-%d 7:00") : params[:date_start]
    @date_end = params[:date_end].nil? ? Time.now.strftime("%Y-%m-%d 7:00") : params[:date_end]
    @source_location_id = params[:source_location_id].nil? ? current_user.location_id : params[:source_location_id]
    @title = '要货报表'

    @order_items = OrderItem.generate_report_data(@date_start, @date_end, @source_location_id)

    #获得发货数据，注：包括外库和工厂库
    packages = Package.generate_report_data(ReportType::Entry, @date_start, @date_end, @source_location_id)
    @removal_packages = {}
    @all_orders = {}

    @order_items.inject(@all_orders) { |h, oi|
      if h["#{oi.part_id}#{oi.whouse_id}"].nil?
        h["#{oi.part_id}#{oi.whouse_id}"] = 0
      end
      h["#{oi.part_id}#{oi.whouse_id}"] += oi.total
      h
    }

    packages.inject(@removal_packages) { |h, p|
      if h["#{p['part_id']}#{p['whouse']}"].nil?
        h["#{p['part_id']}#{p['whouse']}"] = {'count' => 0, 'box' => 0}
      end
      h["#{p['part_id']}#{p['whouse']}"]['count'] += p['count']
      h["#{p['part_id']}#{p['whouse']}"]['box'] += p['box']
      h
    }

    filename = "#{Location.find_by_id(@source_location_id).name}的#{@title}_#{@date_start}_#{@date_end}"

    respond_to do |format|
      format.csv do
        send_data(order_report_csv(@order_items, @removal_packages, @all_orders),
                  :type => "text/csv;charset=utf-8; header=present",
                  :filename => filename+".csv")
      end

      format.xlsx do
        send_data(order_report_xlsx(@order_items, @removal_packages, @all_orders),
                  :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet",
                  :filename => filename+".xlsx"
        )
      end
      format.html
    end
  end

  private

  def order_report_xlsx order_items, removal_packages, all_orders
    p = Axlsx::Package.new
    wb = p.workbook
    wb.add_worksheet(:name => "Basic Sheet") do |sheet|
      sheet.add_row ["No.", "零件号", "总数", "箱数", "部门", "要货人", "状态", "已发货总数", "已发货箱数", "差异数（要货总数-已发运总数）"]
      order_items.each_with_index { |o, index|
        sheet.add_row [
                          index+1,
                          o.part_id,
                          o.total,
                          o.box_count,
                          o.whouse_id,
                          o.user_id,
                          OrderItemState.display(o.state),
                          removal_packages["#{o.part_id}#{o.whouse_id}"].nil? ? "" : removal_packages["#{o.part_id}#{o.whouse_id}"]['count'],
                          removal_packages["#{o.part_id}#{o.whouse_id}"].nil? ? "" : removal_packages["#{o.part_id}#{o.whouse_id}"]['box'],
                          removal_packages["#{o.part_id}#{o.whouse_id}"].nil? ? "" : all_orders["#{o.part_id}#{o.whouse_id}"] - removal_packages["#{o.part_id}#{o.whouse_id}"]['count']
                      ], :types => [:string]
        removal_packages["#{o.part_id}#{o.whouse_id}"] = nil
      }
    end
    p.to_stream.read
  end

  def entry_discrepancy_xlsx packages, results
    p = Axlsx::Package.new
    wb = p.workbook
    wb.add_worksheet(:name => "Basic Sheet") do |sheet|
      sheet.add_row discrepancy_header
      results.each { |k, v|
        sheet.add_row [
                          v["PartNr."],
                          v["Warehouse"],
                          v["Amount"],
                          packages[k].nil? ? 0 : packages[k]["Amount"],
                          packages[k].nil? ? v["Amount"] : v["Amount"] - packages[k]["Amount"]
                      ], :types => [:string]
      }
    end
    p.to_stream.read
  end

  def entry_with_xlsx packages, commit_value
    p = Axlsx::Package.new
    wb = p.workbook
    wb.add_worksheet(:name => "Basic Sheet") do |sheet|
      if commit_value == "详细"
        sheet.add_row entry_header_detials
        packages.each_with_index { |p, index|

          f= p.parent.nil? ? nil : p.parent
          d=(f.nil? || f.parent.nil?) ? nil : f.parent
          s=p.records.where(impl_action: 'dispatch').last
          r=p.records.where(impl_action: 'receive').last

          part=Part.find_by_id(p['part_id'])
          location=Location.find_by_id(p['whouse'])

          #["编号", "运单号","托盘号","唯一码", "零件号", "总数", "箱数","部门","状态","FIFO","发运时间","入库时间"]
          sheet.add_row [
                            index+1,
                            d.nil? ? nil : d.container_id,
                            f.nil? ? nil : f.container_id,
                            p['containers_id'],
                            part.nil? ? nil : part.nr,
                            p['count'],
                            p['box'],
                            location.nil? ? nil : location.nr,
                            MovableState.display(p['state']),
                            p['FIFO'],
                            s.nil? ? nil : s.impl_time.localtime,
                            r.nil? ? nil : r.impl_time.localtime
                        #DatetimeHelper.ddate(p['ddate'])
                        ], :types => [:string]
        }
      else
        sheet.add_row entry_header_total
        packages.each_with_index { |p, index|
          part=Part.find_by_id(p['part_id'])
          location=Location.find_by_id(p['whouse'])

          sheet.add_row [
                            index+1,
                            part.nil? ? nil : part.nr,
                            p['count'],
                            p['box'],
                            location.nil? ? nil : location.nr,
                            MovableState.display(p['state'])
                        #DatetimeHelper.ddate(p['ddate'])
                        ], :types => [:string]
        }
      end
    end
    p.to_stream.read
  end

  def order_report_csv order_items, removal_packages, all_orders
    CSV.generate do |csv|
      csv << ["No.", "零件号", "总数", "箱数", "部门", "要货人", "状态", "已发货总数", "已发货箱数", "差异数（要货总数-已发运总数）"]

      order_items.each_with_index { |o, index|
        csv <<[
            index+1,
            o.part_id,
            o.total,
            o.box_count,
            o.whouse_id,
            o.user_id,
            OrderItemState.display(o.state),
            removal_packages["#{o.part_id}#{o.whouse_id}"].nil? ? "" : removal_packages["#{o.part_id}#{o.whouse_id}"]['count'],
            removal_packages["#{o.part_id}#{o.whouse_id}"].nil? ? "" : removal_packages["#{o.part_id}#{o.whouse_id}"]['box'],
            removal_packages["#{o.part_id}#{o.whouse_id}"].nil? ? "" : all_orders["#{o.part_id}#{o.whouse_id}"] - removal_packages["#{o.part_id}#{o.whouse_id}"]['count']

        ]
        removal_packages["#{o.part_id}#{o.whouse_id}"] = nil
      }
    end
  end

  def entry_with_csv(packages)
    CSV.generate do |csv|
      csv << entry_header

      packages.each_with_index do |p, index|
        csv << [
            index+1,
            p.part_id,
            p.total,
            p.box_count,
            p.whouse_id,
            p.rdate.nil? ? '' : p.rdate.localtime.to_formatted_s(:db),
            p.receover_id.nil? ? '' : User.find_by_id(p.receover_id).name,
            p.state == PackageState::RECEIVED ? "是" : "否"
        ]
      end
    end
  end

  def removal_with_csv(packages)
    CSV.generate do |csv|
      csv << removal_header

      packages.each_with_index do |p, index|
        csv << [
            index+1,
            p.part_id,
            p.total,
            p.box_count,
            p.whouse_id,
            p.ddate.nil? ? '' : p.ddate.localtime.to_formatted_s(:db),
            p.sender_id.nil? ? '' : User.find_by_id(p.sender_id).name,
            p.state == PackageState::DESTINATION ? "是" : "否"
        ]
      end

    end
  end

  def stockout_with_xlsx(items)
    p = Axlsx::Package.new
    wb = p.workbook
    wb.add_worksheet(:name => "Basic Sheet") do |sheet|
      sheet.add_row ["ID", "零件号", "需求数量", "发货数量", "缺货数量", "现有库存数量"]
      items.keys.each_with_index do |key, i|
        if items[key][:order_count].to_i<=items[key][:send_count].to_i
          next
        end
        part=Part.find_by_id(key)
        sheet.add_row [
                          i+1,
                          part.blank? ? key : part.nr,
                          items[key][:order_count].to_i,
                          items[key][:send_count].to_i,
                          items[key][:order_count].to_i-items[key][:send_count].to_i,
                          items[key][:stock_count].to_i
                      ], :types => [:string, :string, :string, :string, :string]
      end
    end
    p.to_stream.read
  end

  def entry_header
    ["编号", "零件号", "总数", "箱数", "部门", "时间"]
  end

  def entry_header_detials
    ["编号", "运单号", "托盘号", "唯一码", "零件号", "总数", "箱数", "部门", "状态", "FIFO", "发运时间", "入库时间"]
  end

  def entry_header_total
    ["编号", "零件号", "总数", "箱数", "部门", "状态"]
  end

  # def entry_header
  #   ["编号", "零件号", "总数", "箱数","部门","状态","时间"]
  # end


  def removal_header
    ["编号", "零件号", "总数", "箱数", "部门", "创建时间", "发货人", "是否被拒绝"]
  end

  def discrepancy_header
    ["零件号", "部门", "报表数量", "系统数量", "差值"]
  end

  def fors_keys
    ["PartNr.", "Warehouse", "Quantity"]
  end
end
