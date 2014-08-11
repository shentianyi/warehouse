# encoding: utf-8
class ReportsController < ApplicationController
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
        condition["deliveries.state"] = [DeliveryState::WAY,DeliveryState::DESTINATION,DeliveryState::RECEIVED]
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
        condition["deliveries.state"] = [DeliveryState::WAY,DeliveryState::DESTINATION,DeliveryState::RECEIVED]
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
    condition["deliveries.destination_id"] = @location_id
    condition["deliveries.received_date"] = time_range
    condition["packages.state"] = [PackageState::RECEIVED]

    @packages = Package.entry_report(condition)

    f = FileData.new(JSON.parse(params[:file]))

    book = Roo::Excelx.new f.full_path

    book.default_sheet = book.sheets.first
    headers = []
    book.row(1).each {|header|
      headers << header
    }

    fors_data = []
    2.upto(book.last_row) do |line|
      params ={}
      headers.each_with_index{|key,i|
        params[key]=book.cell(line,i+1)
      }

      _params = {}
      fors_keys.each{|key|
        _params[key] = params[key]
      }
      fors_data<<_params
    end

    

    respond_to do|format|
      format.html
    end
  end

  def removal_discrepancy

  end

  private
  def entry_with_xlsx packages
    p = Axlsx::Package.new
    wb = p.workbook
    wb.add_worksheet(:name=>"Basic Sheet") do |sheet|
      sheet.add_row entry_header
      packages.each_with_index { |p,index|
        sheet.add_row [
                          index+1,
                          p.part_id,
                          p.total,
                          p.box_count,
                          p.whouse_id,
                          p.rdate.nil? ? '' : p.rdate.localtime.to_formatted_s(:db),
                          p.receover_id.nil? ? '' : User.find_by_id(p.receover_id).name,
                          p.state == PackageState::RECEIVED ? "是":"否"
                      ], :types => [:string]
      }
    end
    p.to_stream.read
  end

  def removal_with_xlsx packages
    p = Axlsx::Package.new
    wb = p.workbook
    wb.add_worksheet(:name=>"Basic Sheet") do |sheet|
      sheet.add_row removal_header
      packages.each_with_index { |p,index|
        sheet.add_row [
                          index+1,
                          p.part_id,
                          p.total,
                          p.box_count,
                          p.whouse_id,
                          p.ddate.nil? ? '' : p.ddate.localtime.to_formatted_s(:db),
                          p.sender_id.nil? ? '' : User.find_by_id(p.sender_id).name,
                          p.state == PackageState::DESTINATION ? "是":"否"
                      ], :types => [:string]
      }
    end
    p.to_stream.read
  end

  def entry_with_csv(packages)
    CSV.generate do |csv|
      csv << entry_header

      packages.each_with_index do |p,index|
        csv << [
            index+1,
            p.part_id,
            p.total,
            p.box_count,
            p.whouse_id,
            p.rdate.nil? ? '' : p.rdate.localtime.to_formatted_s(:db),
            p.receover_id.nil? ? '' : User.find_by_id(p.receover_id).name,
            p.state == PackageState::RECEIVED ? "是":"否"
        ]
      end
    end
  end

  def removal_with_csv(packages)
    CSV.generate do |csv|
      csv << removal_header

      packages.each_with_index do |p,index|
        csv << [
            index+1,
            p.part_id,
            p.total,
            p.box_count,
            p.whouse_id,
            p.ddate.nil? ? '' : p.ddate.localtime.to_formatted_s(:db),
            p.sender_id.nil? ? '' : User.find_by_id(p.sender_id).name,
            p.state == PackageState::DESTINATION ? "是":"否"
        ]
      end

    end
  end

  def filter_fors_excel file
    book = Roo::Excelx.new file
    book.default_sheet = book.sheets.first

    fors_data = []
    2.upto(book.last_row) do |line|
      params = {}
      fors_keys.each_with_index{|key,index|
        params[key] = book.cell(line,i+1)
      }
      puts "========================="
      puts params
    end
  end

  def entry_header
    ["编号", "零件号","总数","箱数","部门","收货时间","收货人","已接收"]
  end

  def removal_header
    ["编号", "零件号","总数","箱数","部门","发货时间","发货人","是否被拒绝"]
  end

  def fors_keys
    ["PartNr.","Warehouse","Quantity"]
  end
end
