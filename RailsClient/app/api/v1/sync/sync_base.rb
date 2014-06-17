module V1
  module Sync
    class SyncBase < ApplicationAPI
      include OauthAPIGuard
      version 'v1', :using => :path
      namespace 'sync'

      mount UserSyncAPI
      mount DeliverySyncAPI
      mount ForkliftSyncAPI
    end
  end
end
