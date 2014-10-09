# encoding: utf-8
class ReportsController < ApplicationController
  def reports
    @type = params[:type].nil? ? ReportType::Entry : params[:type]
    @date_start = params[:date_start].nil? ? 1.day.ago.strftime("%Y-%m-%d 7:00") : params[:date_start]
    @date_end = params[:date_end].nil? ? Time.now.strftime("%Y-%m-%d 7:00") : params[:date_end]
    @location_id = params[:location_id].nil? ? current_user.location_id : params[:location_id]
    @title = ''
    case @type.to_i
      when ReportType::Entry
        @title = 'Entry Report'
      when ReportType::Removal
        @title = 'Removal Report'
      when ReportType::Discrepancy
        @title = 'Discrepancy Report'
    end
    #generate condition
    condition = Package.generate_report_condition(@type, @date_start, @date_end, @location_id)
    @packages = Package.search(condition)
    if @type.to_i == ReportType::Discrepancy

    end

    filename = "#{Location.find_by_id(@location_id).name}#{@title}_#{@date_start}_#{@date_end}"

    respond_to do |format|
      format.csv do
        send_data(Package.export_to_csv(@packages),
                  :type => "text/csv;charset=utf-8; header=present",
                  :filename => filename+".csv")
      end

      format.xlsx do
        send_data(Package.export_to_xlsx(@packages),
                  :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet",
                  :filename => filename+".xlsx"
        )
      end
      format.html
    end
  end

  def entry_report
    @location_id = params[:location_id].nil? ? current_user.location_id : params[:location_id]
    @received_date_start = params[:received_date_start].nil? ? 1.day.ago.strftime("%Y-%m-%d 7:00") : params[:received_date_start]
    @received_date_end = params[:received_date_end].nil? ? Time.now.strftime("%Y-%m-%d 7:00") : params[:received_date_end]
    time_range = Time.parse(@received_date_start).utc..Time.parse(@received_date_end).utc
    @type=params[:type].nil? ? "total" : params[:type]

    condition = {}
    condition["deliveries.destination_id"] = @location_id
    condition["deliveries.received_date"] = time_range
    report = ""
    case @type
      when "total"
        condition["deliveries.state"] = [DeliveryState::WAY, DeliveryState::DESTINATION, DeliveryState::RECEIVED]
        report = "收货报表"
      when "received"
        condition["packages.state"] = [PackageState::RECEIVED]
        report = "实际收货报表"
      when "rejected"
        condition["packages.state"] = [PackageState::DESTINATION]
        report = "拒收报表"
    end

    @packages = Package.entry_report(condition)
    filename = "#{Location.find_by_id(@location_id).name}#{report}_#{@received_date_start}_#{@received_date_end}"
    respond_to do |format|
      format.csv do
        send_data(entry_with_csv(@packages),
                  :type => "text/csv;charset=utf-8; header=present",
                  :filename => filename+".csv")
      end
      format.xls do
        headers['Content-Type'] = "application/vnd.ms-excel"
        headers["Content-disposition"] = "inline;  filename=#{filename}.xls"
        headers['Cache-Control'] = ''
      end
      format.xlsx do
        send_data(entry_with_xlsx(@packages),
                  :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet",
                  :filename => filename+".xlsx"
        )
      end
      format.html
    end
  end

  def removal_report
    @location_id = params[:location_id].nil? ? current_user.location_id : params[:location_id]
    @received_date_start = params[:received_date_start].nil? ? 1.day.ago.strftime("%Y-%m-%d 7:00") : params[:received_date_start]
    @received_date_end = params[:received_date_end].nil? ? Time.now.strftime("%Y-%m-%d 7:00") : params[:received_date_end]
    time_range = Time.parse(@received_date_start).utc..Time.parse(@received_date_end).utc
    @type=params[:type].nil? ? "total" : params[:type]

    condition = {}
    condition["deliveries.source_id"] = @location_id
    condition["deliveries.delivery_date"] = time_range

    report = ""
    case @type
      when "total"
        condition["deliveries.state"] = [DeliveryState::WAY, DeliveryState::DESTINATION, DeliveryState::RECEIVED]
        report="发货报表"
      when "send"
        condition["packages.state"] = [PackageState::RECEIVED]
        report = "实际发货报表"
      when "rejected"
        condition["packages.state"] = [PackageState::DESTINATION]
        report = "被拒收报表"
    end
    @packages = Package.removal_report(condition)

    filename = "#{Location.find_by_id(@location_id).name}#{report}_#{@received_date_start}_#{@received_date_end}"

    respond_to do |format|
      format.html
      format.csv do
        send_data(removal_with_csv(@packages),
                  :type => "text/csv;charset=utf-8; header=present",
                  :filename => "#{filename}.csv")
      end
      format.xls do
        headers['Content-Type'] = "application/vnd.ms-excel"
        headers["Content-disposition"] = "inline;  filename=#{filename}.xls"
        headers['Cache-Control'] = ''
      end
      format.xlsx do
        send_data(removal_with_xlsx(@packages),
                  :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet",
                  :filename => filename+".xlsx"
        )
      end
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

  def entry_discrepancy
    @location_id = params[:location_id].nil? ? current_user.location_id : params[:location_id]
    @received_date_start = params[:received_date_start].nil? ? 1.day.ago.strftime("%Y-%m-%d 7:00") : params[:received_date_start]
    @received_date_end = params[:received_date_end].nil? ? Time.now.strftime("%Y-%m-%d 7:00") : params[:received_date_end]
    time_range = Time.parse(@received_date_start).utc..Time.parse(@received_date_end).utc

    condition = {}
    #condition["packages.part_id"] = 'P00112425'
    condition["deliveries.destination_id"] = @location_id
    #condition["deliveries.received_date"] = time_range
    #condition["deliveries.created_at"] = time_range
    condition["packages.created_at"] = time_range
    condition["packages.state"] = [PackageState::RECEIVED]

    @packages = {}

    Package.entry_report(condition).each { |p|
      if @packages[p.part_id+p.whouse_id].nil?
        @packages[p.part_id+p.whouse_id] = {"PartNr." => p.part_id, "Warehouse" => p.whouse_id, "Amount" => 0}
      end
      @packages[p.part_id+p.whouse_id]["Amount"] = @packages[p.part_id+p.whouse_id]["Amount"] + p.total
    }

    @uncounted_packages = {}
    condition["packages.state"] = [PackageState::WAY, PackageState::ORIGINAL]
    Package.entry_report(condition).each { |p|
      if @uncounted_packages[p.part_id+p.whouse_id].nil?
        @uncounted_packages[p.part_id+p.whouse_id] = {"PartNr." => p.part_id, "Warehouse" => p.whouse_id, "Amount" => 0}
      end
      @uncounted_packages[p.part_id+p.whouse_id]["Amount"] = @uncounted_packages[p.part_id+p.whouse_id]["Amount"] + p.total
    }

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

    filename = "#{Location.find_by_id(@location_id).name}收货差异报表_#{@received_date_start}_#{@received_date_end}"

    respond_to do |format|
      format.html
      format.xlsx do
        send_data(entry_discrepancy_xlsx(@packages, @results, @uncounted_packages),
                  :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet",
                  :filename => filename+".xlsx"
        )
      end
    end
  end

  def removal_discrepancy
    @location_id = params[:location_id].nil? ? current_user.location_id : params[:location_id]
    @received_date_start = params[:received_date_start].nil? ? 1.day.ago.strftime("%Y-%m-%d 7:00") : params[:received_date_start]
    @received_date_end = params[:received_date_end].nil? ? Time.now.strftime("%Y-%m-%d 7:00") : params[:received_date_end]
    time_range = Time.parse(@received_date_start).utc..Time.parse(@received_date_end).utc

    condition = {}
    condition["deliveries.destination_id"] = @location_id
    condition["deliveries.received_date"] = time_range
    condition["packages.state"] = [PackageState::RECEIVED]

    @packages = {}

    Package.entry_report(condition).each { |p|
      if @packages[p.part_id+p.whouse_id].nil?
        @packages[p.part_id+p.whouse_id] = {"PartNr." => p.part_id, "Warehouse" => p.whouse_id, "Amount" => 0}
      end
      @packages[p.part_id+p.whouse_id]["Amount"] = @packages[p.part_id+p.whouse_id]["Amount"] + p.total
    }

    @results = {}

    unless params[:file].nil?

      f = FileData.new(JSON.parse(params[:file]))

      book = Roo::Excelx.new f.full_path

      book.default_sheet = book.sheets.first
      headers = []
      book.row(1).each { |header|
        headers << header
      }

      fors_data = []
      2.upto(book.last_row) do |line|
        params ={}
        headers.each_with_index { |key, i|
          params[key]=book.cell(line, i+1).to_s
        }

        _params = {}
        fors_keys.each { |key|
          if  params[key].is_number?
            _params[key] = params[key].to_i.to_s
          else
            _params[key] = params[key]
          end
        }
        fors_data<<_params
      end

      fors_data.each { |f|
        if @results[f["PartNr."]+f["Warehouse"]].nil?
          @results[f["PartNr."]+f["Warehouse"]] = {"PartNr." => f["PartNr."], "Warehouse" => f["Warehouse"], "Amount" => 0}
        end
        @results[f["PartNr."]+f["Warehouse"]]["Amount"] = @results[f["PartNr."]+f["Warehouse"]]["Amount"] + f["Quantity"].to_f
      }
    end

    filename = "#{Location.find_by_id(@location_id).name}收货差异报表_#{@received_date_start}_#{@received_date_end}"

    respond_to do |format|
      format.html
      format.xlsx do
        send_data(entry_discrepancy_xlsx(@packages, @results),
                  :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet",
                  :filename => filename+".xlsx"
        )
      end
    end
  end

  def orders_report
    @date_start = params[:date_start].nil? ? 1.day.ago.strftime("%Y-%m-%d 7:00") : params[:date_start]
    @date_end = params[:date_end].nil? ? Time.now.strftime("%Y-%m-%d 7:00") : params[:date_end]
    time_range = Time.parse(@date_start).utc..Time.parse(@date_end).utc
    @title = '要货报表'
    condition = {}
    condition['order_items.created_at']= time_range
    @order_items = OrderItem.joins(:order)
    .where(condition).select('order_items.part_id,SUM(order_items.box_quantity) as box_count,SUM(order_items.quantity) as total,order_items.whouse_id as whouse_id,order_items.is_finished ,order_items.out_of_stock,order_items.user_id as user_id')
    .group('part_id,whouse_id,is_finished,out_of_stock,user_id').order("whouse_id DESC").all

    filename = "#{@title}_#{@date_start}_#{@date_end}"

    respond_to do |format|
      format.csv do
        send_data(order_report_csv(@order_items),
                  :type => "text/csv;charset=utf-8; header=present",
                  :filename => filename+".csv")
      end

      format.xlsx do
        send_data(order_report_xlsx(@order_items),
                  :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet",
                  :filename => filename+".xlsx"
        )
      end
      format.html
    end
  end

  private

  def order_report_xlsx order_items
    p = Axlsx::Package.new
    wb = p.workbook
    wb.add_worksheet(:name => "Basic Sheet") do |sheet|
      sheet.add_row ["No.", "零件号", "总数", "箱数", "部门", "要货人", "状态"]
      order_items.each_with_index { |o, index|
        sheet.add_row [
                          index+1,
                          o.part_id,
                          o.total,
                          o.box_count,
                          o.whouse_id,
                          o.user_id,
                          o.state
                      ], :types => [:string]
      }
    end
    p.to_stream.read
  end

  def entry_discrepancy_xlsx packages, results, uncounted_packages
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
                          packages[k].nil? ? v["Amount"] : v["Amount"] - packages[k]["Amount"],
                          uncounted_packages[k].nil? ? 0 : uncounted_packages[k]["Amount"]
                      ], :types => [:string]
      }
    end
    p.to_stream.read
  end

  def entry_with_xlsx packages
    p = Axlsx::Package.new
    wb = p.workbook
    wb.add_worksheet(:name => "Basic Sheet") do |sheet|
      sheet.add_row entry_header
      packages.each_with_index { |p, index|
        sheet.add_row [
                          index+1,
                          p.part_id,
                          p.total,
                          p.box_count,
                          p.whouse_id,
                          p.rdate.nil? ? '' : p.rdate.localtime.to_formatted_s(:db),
                          p.receover_id.nil? ? '' : User.find_by_id(p.receover_id).name,
                          p.state == PackageState::RECEIVED ? "是" : "否"
                      ], :types => [:string]
      }
    end
    p.to_stream.read
  end

  def removal_with_xlsx packages
    p = Axlsx::Package.new
    wb = p.workbook
    wb.add_worksheet(:name => "Basic Sheet") do |sheet|
      sheet.add_row removal_header
      packages.each_with_index { |p, index|
        sheet.add_row [
                          index+1,
                          p.part_id,
                          p.total,
                          p.box_count,
                          p.whouse_id,
                          p.ddate.nil? ? '' : p.ddate.localtime.to_formatted_s(:db),
                          p.sender_id.nil? ? '' : User.find_by_id(p.sender_id).name,
                          p.state == PackageState::DESTINATION ? "是" : "否"
                      ], :types => [:string]
      }
    end
    p.to_stream.read
  end

  def order_report_csv order_items
    CSV.generate do |csv|
      csv << ["No.", "零件号", "总数", "箱数", "部门", "要货人", "状态"]

      order_items.each_with_index { |o, index|
        csv <<[
            index+1,
            o.part_id,
            o.total,
            o.box_count,
            o.whouse_id,
            o.user_id,
            o.state
        ]
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

  def entry_header
    ["编号", "零件号", "总数", "箱数", "部门", "收货时间", "收货人", "已接收"]
  end

  def removal_header
    ["编号", "零件号", "总数", "箱数", "部门", "发货时间", "发货人", "是否被拒绝"]
  end

  def discrepancy_header
    ["零件号", "部门", "报表数量", "系统数量", "差值", "未记入统计（未发送或在途）"]
  end

  def fors_keys
    ["PartNr.", "Warehouse", "Quantity"]
  end
end
