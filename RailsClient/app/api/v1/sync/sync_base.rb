module V1
  module Sync
    class SyncBase < ApplicationAPI
      include OauthAPIGuard
      version 'v1', :using => :path
      namespace 'sync'
      mount UserSyncAPI
    end
  end
end
