module V1
  module Sync
    class UserSyncAPI<SyncBase
      namespace 'users'
      guard_all!
      get do
        Hacker.unscoped.where('updated_at>=?', params[:last_time]).all
      end

      post do
        puts params

        user=Hacker.new(JSON.parse(params[:user]))
        #user.save
        puts user
        user.save!
        user
      end

      put '/:id' do
        if user=Hacker.find_by_id(params[:id])
          user.update(JSON.parse(params[:user]))
        end
        user
      end

      delete '/:id' do
        puts params
        puts params[:user]
        if user=Hacker.find_by_id(params[:id])
          user.update(is_delete: true)
        end
        user
      end
    end
  end
end