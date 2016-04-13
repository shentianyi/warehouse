class LocationContainerOrder < ActiveRecord::Base
  belongs_to :logistics_container
  belongs_to :order

end
