class LocationDestination < ActiveRecord::Base
  include Extensions::UUID

  belongs_to :location
  belongs_to :destination, class_name: 'Location'

  validate :destination_location, :on => :create

  def destination_location
    if LocationDestination.where({location_id:self.location_id,destination_id:self.destination_id}).count > 0
      errors.add(:destination_id, '目的地已经存在')
    end
  end
end
