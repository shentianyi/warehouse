module V1
  module Sync
    class RegexCategorySyncAPI<SyncBase
      namespace :regex_categories do
        rescue_from :all do |e|
          RegexCategorySyncAPI.error_unlock_sync_pool('regex_categories')
          Rack::Response.new([e.message], 500).finish
        end
        get do
          RegexCategory.unscoped.where('updated_at>=?', Time.parse(params[:last_time])).all
        end

        post do
          msg=Message.new
          begin
            ActiveRecord::Base.transaction do
              regex_categories=JSON.parse(params[:regex_category])
              regex_categories.each do |regex_category|
                regex_category=RegexCategory.new(regex_category)
                regex_category.save
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
              regex_categories=JSON.parse(params[:regex_category])
              regex_categories.each do |regex_category|
                if u=RegexCategory.unscoped.find_by_id(regex_category['id'])
                  u.update(regex_category.except('id'))
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
              regex_categories=JSON.parse(params[:regex_category])
              regex_categories.each do |id|
                if regex_category=RegexCategory.unscoped.find_by_id(id)
                  regex_category.update(is_delete: true)
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