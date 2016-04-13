class LocationContainerPickList < ActiveRecord::Base
  belongs_to :logistics_container
  belongs_to :pick_list

end
