module V1
  module Sync
    class SyncBase < ApplicationAPI
      include OauthAPIGuard
      include SyncAPIGuard

      version 'v1', :using => :path
      namespace 'sync'
      guard_all!
      lock_sync_pool
      unlock_sync_pool
      mount LocationSyncAPI
      mount UserSyncAPI
      mount WhouseSyncAPI
      mount PartSyncAPI
      mount PositionSyncAPI
      mount DeliverySyncAPI
      mount ForkliftSyncAPI
      mount PackageSyncAPI

      mount PackagePositionSyncAPI
    end
  end
end
