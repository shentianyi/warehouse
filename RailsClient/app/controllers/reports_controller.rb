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

    @packages = {}

    Package.entry_report(condition).each {|p|
      if @packages[p.part_id+p.whouse_id].nil?
        @packages[p.part_id+p.whouse_id] = {"PartNr."=>p.part_id,"Warehouse"=>p.whouse_id,"Amount"=>0}
      end
      @packages[p.part_id+p.whouse_id]["Amount"] = @packages[p.part_id+p.whouse_id]["Amount"] + p.total
    }

    @results = {}
    @file = nil
    @jsonfile = nil
    unless params[:file].nil?
      @file = JSON.parse(params[:file])
      @jsonfile = params[:file]
      f = FileData.new(JSON.parse(params[:file]))

      book = Roo::Excelx.new f.full_path

      book.default_sheet = book.sheets.first
      headers = []
      book.row(1).each {|header|
        headers << header
      }

      res_hash = {}

      fors_data = []
      2.upto(book.last_row) do |line|
        params ={}
        headers.each_with_index{|key,i|
          params[key]=book.cell(line,i+1).to_s
        }

        insert = true
        _params = {}
        fors_keys.each{|key|
          if insert && (params[key].nil? || params[key].to_s.blank?)
            insert = false
            break
          end

          if  params[key].is_number?
            _params[key] = params[key].to_i.to_s
          else
            _params[key] = params[key]
          end
        }

        if insert
          fors_data<<_params
        end
      end

      fors_data.each {|f|
        if res_hash[f["PartNr."]+f["Warehouse"]].nil?
          res_hash[f["PartNr."]+f["Warehouse"]] = {"PartNr."=>f["PartNr."],"Warehouse"=>f["Warehouse"],"Amount"=>0}
        end
        res_hash[f["PartNr."]+f["Warehouse"]]["Amount"] = res_hash[f["PartNr."]+f["Warehouse"]]["Amount"] + f["Quantity"].to_f
      }
    end

    @results = res_hash.sort_by {|key,value| value["Warehouse"]}

    filename = "#{Location.find_by_id(@location_id).name}收货差异报表_#{@received_date_start}_#{@received_date_end}"

    respond_to do|format|
      format.html
      format.xlsx do
        send_data(entry_discrepancy_xlsx(@packages,@results),
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

    Package.entry_report(condition).each {|p|
      if @packages[p.part_id+p.whouse_id].nil?
        @packages[p.part_id+p.whouse_id] = {"PartNr."=>p.part_id,"Warehouse"=>p.whouse_id,"Amount"=>0}
      end
      @packages[p.part_id+p.whouse_id]["Amount"] = @packages[p.part_id+p.whouse_id]["Amount"] + p.total
    }

    @results = {}

    unless params[:file].nil?

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
          params[key]=book.cell(line,i+1).to_s
        }

        _params = {}
        fors_keys.each{|key|
          if  params[key].is_number?
            _params[key] = params[key].to_i.to_s
          else
            _params[key] = params[key]
          end
        }
        fors_data<<_params
      end

      fors_data.each {|f|
        if @results[f["PartNr."]+f["Warehouse"]].nil?
          @results[f["PartNr."]+f["Warehouse"]] = {"PartNr."=>f["PartNr."],"Warehouse"=>f["Warehouse"],"Amount"=>0}
        end
        @results[f["PartNr."]+f["Warehouse"]]["Amount"] = @results[f["PartNr."]+f["Warehouse"]]["Amount"] + f["Quantity"].to_f
      }
    end

    filename = "#{Location.find_by_id(@location_id).name}收货差异报表_#{@received_date_start}_#{@received_date_end}"

    respond_to do|format|
      format.html
      format.xlsx do
        send_data(entry_discrepancy_xlsx(@packages,@results),
                  :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet",
                  :filename => filename+".xlsx"
        )
      end
    end
  end

  private

  def entry_discrepancy_xlsx packages,results
    p = Axlsx::Package.new
    wb = p.workbook
    wb.add_worksheet(:name=>"Basic Sheet") do |sheet|
      sheet.add_row discrepancy_header
      results.each { |k,v|
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

  def entry_header
    ["编号", "零件号","总数","箱数","部门","收货时间","收货人","已接收"]
  end

  def removal_header
    ["编号", "零件号","总数","箱数","部门","发货时间","发货人","是否被拒绝"]
  end

  def discrepancy_header
    ["零件号","部门","报表数量","系统数量","差值"]
  end

  def fors_keys
    ["PartNr.","Warehouse","Quantity"]
  end
end
