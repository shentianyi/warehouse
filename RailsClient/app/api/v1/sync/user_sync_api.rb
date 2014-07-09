module V1
  module Sync
    class UserSyncAPI<SyncBase
      namespace 'hackers'
      rescue_from :all do |e|
        UserSyncAPI.error_unlock_sync_pool('users')
        Rack::Response.new([e.message], 500).finish
      end
      get do
        Hacker.unscoped.where('updated_at>=?', params[:last_time]).all
      end

      post do
        users=JSON.parse(params[:hacker])
        users.each do |user|
          user=Hacker.new(user)
          user.save
        end
      end

      put '/:id' do
        users=JSON.parse(params[:hacker])
        users.each do |user|
          if u=Hacker.unscoped.find_by_id(user['id'])
            u.update(user.except('id'))
          end
        end
      end

      post :delete do
        users=JSON.parse(params[:hacker])
        users.each do |id|
          if user=Hacker.unscoped.find_by_id(id)
            user.update(is_delete: true)
          end
        end
      end
    end
  end
end