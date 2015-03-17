module V1
  module Sync
    class RegexSyncAPI<SyncBase
      namespace :regexes do
        rescue_from :all do |e|
          RegexSyncAPI.error_unlock_sync_pool('regexes')
          Rack::Response.new([e.message], 500).finish
        end
        get do
          Regex.unscoped.where('updated_at>=?', Time.parse(params[:last_time])).all
        end

        post do
          msg=Message.new
          begin
            ActiveRecord::Base.transaction do
              regexes=JSON.parse(params[:regex])
              regexes.each do |regex|
                regex=Regex.new(regex)
                regex.save
              end
            end
            msg.result =true
          rescue => e
            msg.content = "delete:#{e.message}"
          end
          return msg
        end

        put '/:id' do
          msg=Message.new
          begin
            ActiveRecord::Base.transaction do
              regexes=JSON.parse(params[:regex])
              regexes.each do |regex|
                if u=Regex.unscoped.find_by_id(regex['id'])
                  u.update(regex.except('id'))
                end
              end
            end
            msg.result =true
          rescue => e
            msg.content = "delete:#{e.message}"
          end
          return msg
        end

        post :delete do
          msg=Message.new
          begin
            ActiveRecord::Base.transaction do
              regexes=JSON.parse(params[:regex])
              regexes.each do |id|
                if regex=Regex.unscoped.find_by_id(id)
                  regex.update(is_delete: true)
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