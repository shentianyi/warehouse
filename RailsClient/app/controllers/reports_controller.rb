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

    case @type
      when "total"
        condition["deliveries.state"] = [DeliveryState::WAY,DeliveryState::DESTINATION,DeliveryState::RECEIVED]
      when "received"
        condition["packages.state"] = [PackageState::RECEIVED]
      when "rejected"
        condition["packages.state"] = [PackageState::DESTINATION]
    end
    @packages = Package.joins(:part).joins(forklift: :delivery)
    .where(condition)
    .select("parts.unit_pack as upack,packages.state,packages.part_id,COUNT(packages.id) as count,forklifts.whouse_id as whouse_id,deliveries.received_date as rdate,deliveries.receiver_id as receover_id,deliveries.id as did")
    .group("packages.part_id").order("rdate DESC,did,whouse_id")
    render
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

    case @type
      when "total"
        condition["deliveries.state"] = [DeliveryState::WAY,DeliveryState::DESTINATION,DeliveryState::RECEIVED]
      when "send"
        condition["packages.state"] = [PackageState::RECEIVED]
      when "rejected"
        condition["packages.state"] = [PackageState::DESTINATION]
    end
    @packages = Package.joins(:part).joins(forklift: :delivery)
    .where(condition)
    .select("parts.unit_pack as upack,packages.state,packages.part_id,COUNT(packages.id) as count,forklifts.whouse_id as whouse_id,deliveries.delivery_date as ddate,deliveries.user_id as sender_id,deliveries.id as did")
    .group("packages.part_id").order("ddate DESC,did ,whouse_id ")
    render
  end

  def entry_download
    @location_id = params[:location_id].nil? ? current_user.location_id : params[:location_id]
    @received_date_start = params[:received_date_start].nil? ? 1.day.ago.strftime("%Y-%m-%d 7:00") : params[:received_date_start]
    @received_date_end = params[:received_date_end].nil? ? Time.now.strftime("%Y-%m-%d 7:00") : params[:received_date_end]
    time_range = Time.parse(@received_date_start).utc..Time.parse(@received_date_end).utc
    @type=params[:type].nil? ? "total" : params[:type]

    condition = {}
    condition["deliveries.destination_id"] = @location_id
    condition["deliveries.received_date"] = time_range

    case @type
      when "total"
        condition["deliveries.state"] = [DeliveryState::WAY,DeliveryState::DESTINATION,DeliveryState::RECEIVED]
      when "received"
        condition["packages.state"] = [PackageState::RECEIVED]
      when "rejected"
        condition["packages.state"] = [PackageState::DESTINATION]
    end

    @packages = Package.joins(:part).joins(forklift: :delivery)
    .where(condition)
    .select("parts.unit_pack as upack,packages.state,packages.part_id,COUNT(packages.id) as count,forklifts.whouse_id as whouse_id,deliveries.received_date as rdate,deliveries.receiver_id as receover_id,deliveries.id as did")
    .group("packages.part_id").order("rdate DESC,did,whouse_id")

    filename = "Report_Entry_#{Location.find_by_id(@location_id).name}_#{@type}_#{Time.now.to_i}.csv"

    respond_to do |format|
      format.csv do
        send_data(csv_content_entry(@packages),
                  :type => "text/csv;charset=utf-8; header=present",
                  :filename => filename)
      end
    end
  end

  def removal_download
    @location_id = params[:location_id].nil? ? current_user.location_id : params[:location_id]
    @received_date_start = params[:received_date_start].nil? ? 1.day.ago.strftime("%Y-%m-%d 7:00") : params[:received_date_start]
    @received_date_end = params[:received_date_end].nil? ? Time.now.strftime("%Y-%m-%d 7:00") : params[:received_date_end]
    time_range = Time.parse(@received_date_start).utc..Time.parse(@received_date_end).utc
    @type=params[:type].nil? ? "total" : params[:type]

    condition = {}
    condition["deliveries.source_id"] = @location_id
    condition["deliveries.delivery_date"] = time_range

    case @type
      when "total"
        condition["deliveries.state"] = [DeliveryState::WAY,DeliveryState::DESTINATION,DeliveryState::RECEIVED]
      when "send"
        condition["packages.state"] = [PackageState::RECEIVED]
      when "rejected"
        condition["packages.state"] = [PackageState::DESTINATION]
    end
    @packages = Package.joins(:part).joins(forklift: :delivery)
    .where(condition)
    .select("parts.unit_pack as upack,packages.state,packages.part_id,COUNT(packages.id) as count,forklifts.whouse_id as whouse_id,deliveries.delivery_date as ddate,deliveries.user_id as sender_id,deliveries.id as did")
    .group("packages.part_id").order("ddate DESC,did ,whouse_id ")

    filename = "Report_Removal_#{Location.find_by_id(@location_id).name}_#{@type}_#{Time.now.to_i}.csv"

    respond_to do |format|
      format.csv do
        send_data(csv_content_removal(@packages),
                  :type => "text/csv;charset=utf-8; header=present",
                  :filename => filename)
      end
    end
  end


  private
  def csv_content_entry(packages)
    CSV.generate do |csv|
      csv << ["编号", "零件号","最小包装量","箱数","部门","运单号","收货时间","收货人","已接收"]

      packages.each_with_index do |p,index|
        csv << [
            index+1,
            p.part_id,
            p.upack,
            p.count,
            p.whouse_id,
            p.did,
            p.rdate.nil? ? '' : p.rdate.localtime.to_formatted_s(:db),
            p.receover_id.nil? ? '' : User.find_by_id(p.receover_id).name,
            p.state == PackageState::RECEIVED ? "是":"否"
        ]
      end
    end
  end

  def csv_content_removal(packages)
    CSV.generate do |csv|
      csv << ["编号", "零件号","最小包装量","箱数","部门","运单号","发货时间","发货人","是否被拒绝"]

      packages.each_with_index do |p,index|
        csv << [
            index+1,
            p.part_id,
            p.upack,
            p.count,
            p.whouse_id,
            p.did,
            p.ddate.nil? ? '' : p.ddate.localtime.to_formatted_s(:db),
            p.sender_id.nil? ? '' : User.find_by_id(p.sender_id).name,
            p.state == PackageState::DESTINATION ? "是":"否"
        ]
      end

    end
  end
end
