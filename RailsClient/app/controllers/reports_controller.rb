# encoding: utf-8
class ReportsController < ApplicationController
  def entry_report
    @location_id = params[:location_id].nil? ? current_user.location_id : params[:location_id]
    @received_date_start = params[:received_date_start].nil? ? 1.day.ago.strftime("%Y-%m-%d 7:00:00") : params[:received_date_start]
    @received_date_end = params[:received_date_end].nil? ? Time.now.strftime("%Y-%m-%d 7:00:00") : params[:received_date_end]
    time_range = Time.parse(@received_date_start).utc..Time.parse(@received_date_end).utc

    #add state
    @packages = Delivery.includes(forklifts: :packages).where("destination_id"=>@location_id,"received_date" => time_range).paginate(:page=>params[:page])
    #render :entry_report
  end
end
