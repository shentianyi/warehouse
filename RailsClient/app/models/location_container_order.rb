class LocationContainerOrder < ActiveRecord::Base
  belongs_to :location_container
  belongs_to :order

end
