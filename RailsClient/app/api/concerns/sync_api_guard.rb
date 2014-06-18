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
    def lock_sync_pool
      before do
        if $OPEN_SYN_LOCK
          tb= get_table_name
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
    end

    def unlock_sync_pool
      after do
        if $OPEN_SYN_LOCK
          tb= get_table_name
          if table=SyncPool.find_by_table_name(tb)
            table.update(locked: false)
          end
        end
      end
    end

    def error_unlock_sync_pool(tb)
      puts 'error unlock'
      if $OPEN_SYN_LOCK
        if table=SyncPool.find_by_table_name(tb)
          table.update(locked: false)
        end
      end
    end
  end
end