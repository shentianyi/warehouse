module V1
  module Sync
    class UserSyncAPI<SyncBase
      namespace 'users'
      guard_all!
      get do
        puts params[:last_time]
        User.where('updated_at>=?', params[:last_time]).all
      end

      post do
        puts params
        puts params[:user].class
        user=User.new(JSON.parse(params[:user]))
        user.save
        user
      end
      put '/:id' do
        if user=User.find_by_id(params[:id])
          puts params[:user]
          user.update(params[:user].to_hash)
        end
        user
      end

      delete '/:id' do
        puts params
        puts params[:user]
        if user=User.find_by_id(params[:id])
          user.update(is_delete: true)
        end
        user
      end
    end
  end
end