# encoding: utf-8
class ReportsController < ApplicationController
  def entry_report
    @location_id = params[:location_id].nil? ? current_user.location_id : params[:location_id]
    @received_date_start = params[:received_date_start].nil? ? 1.day.ago.strftime("%Y-%m-%d 7:00:00") : params[:received_date_start]
    @received_date_end = params[:received_date_end].nil? ? Time.now.strftime("%Y-%m-%d 7:00:00") : params[:received_date_end]
    time_range = Time.parse(@received_date_start).utc..Time.parse(@received_date_end).utc
    @report_type = params[:report_type].nil? ? "total" : params[:report_type]
    case @report_type
      when "total"
        puts "total"
        @packages = Package.joins(forklift: :delivery)
        .where("deliveries.destination_id"=>@location_id,"deliveries.received_date" => time_range,"deliveries.state" => [DeliveryState::WAY,DeliveryState::DESTINATION,DeliveryState::RECEIVED])
        .select("packages.part_id,COUNT(packages.id) as count,forklifts.whouse_id as whouse_id")
        .group("packages.part_id").order("forklifts.whouse_id")
      when "received"
        @packages = Package.joins(forklift: :delivery)
        .where("deliveries.destination_id"=>@location_id,"deliveries.received_date" => time_range,"packages.state" => [PackageState::RECEIVED])
        .select("packages.part_id,COUNT(packages.id) as count,forklifts.whouse_id as whouse_id")
        .group("packages.part_id").order("forklifts.whouse_id")
      when "rejected"
        @packages = Package.joins(forklift: :delivery)
        .where("deliveries.destination_id"=>@location_id,"deliveries.received_date" => time_range,"packages.state" => [PackageState::DESTINATION])
        .select("packages.part_id,COUNT(packages.id) as count,forklifts.whouse_id as whouse_id")
        .group("packages.part_id").order("forklifts.whouse_id")
    end
    render
  end
end
