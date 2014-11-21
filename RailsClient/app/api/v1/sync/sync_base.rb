module V1
  module Sync
    class SyncBase < ApplicationAPI
      include OauthAPIGuard
      include SyncAPIGuard

      version 'v1', :using => :path
      namespace 'sync'
      guard_all!
      lock_sync_pool


      mount LocationSyncAPI
      mount UserSyncAPI
      mount WhouseSyncAPI
      mount PartTypeSyncAPI
      mount PartSyncAPI
      mount PositionSyncAPI
      mount PartPositionSyncAPI
      mount PickItemFilterSyncAPI

      mount ContainerSyncAPI
      mount LocationContainerSyncAPI
      mount RecordSyncAPI

      mount OrderSyncAPI
      mount OrderItemSyncAPI
      mount PickListSyncAPI
      mount PickItemSyncAPI

    end
  end
end
