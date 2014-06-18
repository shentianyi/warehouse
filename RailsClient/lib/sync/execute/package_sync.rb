module Sync
  module Execute
    class PackageSync< CustomIdSyncBase
      PULL_URL= BASE_URL+'packages'
      POST_URL= BASE_URL+'packages'

      #def self.pull_block
      #  Delivery.skpi_callback(:save, :after, :log_state)
      #  super
      #end
    end
  end
end
