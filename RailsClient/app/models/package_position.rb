class PackagePosition < ActiveRecord::Base
  include Extensions::UUID
  belongs_to :package, :dependent => :destroy
  belongs_to :position, :dependent => :destroy

  FK=[:position_id, :package_id]
end
