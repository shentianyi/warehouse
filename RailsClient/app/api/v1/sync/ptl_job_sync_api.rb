module V1
  module Sync
    class PtlJobSyncAPI<SyncBase
      namespace :ptl_jobs do
        rescue_from :all do |e|
          PtlJobSyncAPI.error_unlock_sync_pool('ptl_jobs')
          Rack::Response.new([e.message], 500).finish
        end
        get do
          PtlJob.unscoped.where('updated_at>=?', params[:last_time]).all
        end

        post do
          msg=Message.new
          begin
            ActiveRecord::Base.transaction do
              ptl_jobs=JSON.parse(params[:ptl_job])
              ptl_jobs.each do |ptl_job|
                ptl_job=PtlJob.new(ptl_job)
                ptl_job.save
              end
            end
            msg.result =true
          rescue => e
            msg.content = "post:#{e.message}"
          end
          return msg
        end

        put '/:id' do
          msg=Message.new
          begin
            ActiveRecord::Base.transaction do
              ptl_jobs=JSON.parse(params[:ptl_job])
              ptl_jobs.each do |ptl_job|
                if u=PtlJob.unscoped.find_by_id(ptl_job['id'])
                  u.update(ptl_job.except('id'))
                end
              end
            end
            msg.result =true
          rescue => e
            msg.content = "put:#{e.message}"
          end
          return msg
        end

        post :delete do
          msg=Message.new
          begin
            ActiveRecord::Base.transaction do
              ptl_jobs=JSON.parse(params[:ptl_job])
              ptl_jobs.each do |id|
                if ptl_job=PtlJob.unscoped.find_by_id(id)
                  ptl_job.update(is_delete: true)
                end
              end
            end
            msg.result =true
          rescue => e
            msg.content = "delete:#{e.message}"
          end
          return msg
        end
      end
    end
  end
end