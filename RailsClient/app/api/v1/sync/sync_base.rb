module V1
  module Sync
    class SyncBase < ApplicationAPI
      include OauthAPIGuard
      include SyncAPIGuard

      version 'v1', :using => :path
      namespace :sync do
        guard_all!
        lock_sync
        lock_sync_pool

        mount LocationSyncAPI
        mount LocationDestinationSyncAPI
        mount UserSyncAPI
        mount WhouseSyncAPI
        mount PartTypeSyncAPI
        mount PartSyncAPI
        mount PositionSyncAPI
        mount PartPositionSyncAPI
        mount PickItemFilterSyncAPI

        mount RegexCategorySyncAPI
        mount RegexSyncAPI

        mount ContainerSyncAPI
        mount LocationContainerSyncAPI
        mount RecordSyncAPI

        mount StorageSyncAPI

        mount OrderSyncAPI
        mount OrderItemSyncAPI
        mount PickListSyncAPI
        mount PickItemSyncAPI
      end
    end
  end
end
