module SyncAPIGuard
  extend ActiveSupport::Concern
  included do |base|
    helpers HelperMethods
  end

  module HelperMethods
    def get_table_name
      params.route_info.instance_variable_get('@options')[:namespace].sub(/\/sync\//, '')
    end
  end

  module ClassMethods
    def lock_sync
      before do
        tb= get_table_name
        if table = SyncLog.find_by_table_name(tb)
          if !table.sync
            table.update(sync: true)
          end
        else
          SyncLog.create(table_name:tb,sync:true)
        end
        if Sync::Config.lock
          #if lock sync return false
          return error!('Sync Locked',423)
        end
      end

      after do
        tb= get_table_name
        if table=SyncLog.find_by_table_name(tb)
          table.update(sync: false)
        end
      end
    end

    def lock_sync_pool
      before do
        tb= get_table_name
        model= tb.singularize.classify.constantize
        Sync::Config.skip_callbacks(model)
        if Sync::Config.sync_lock
          if table=SyncPool.find_by_table_name(tb)
            if table.locked
              return error!('Recourse Locked', 423)
            else
              table.update(locked: true)
            end
          else
            SyncPool.create(table_name: tb)
          end
        end
      end

      after do
        tb= get_table_name
        model = tb.singularize.classify.constantize
        Sync::Config.reset_callbacks(model)
        if Sync::Config.sync_lock
          if table=SyncPool.find_by_table_name(tb)
            table.update(locked: false)
          end
        end
      end
    end

    def error_unlock_sync_pool(tb)
      if Sync::Config.sync_lock
        if table=SyncPool.find_by_table_name(tb)
          table.update(locked: false)
        end
      end
    end
  end
end