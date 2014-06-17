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
        table=get_table_name

      end
    end

    def unlock_sync_pool
      after do
        puts '**************'
      end
    end

  end
end