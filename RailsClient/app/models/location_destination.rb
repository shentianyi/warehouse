class LocationDestination < ActiveRecord::Base
  include Extensions::UUID

  belongs_to :location
  belongs_to :destination, class_name: 'Location'

  validate :validate_save

  private

  def validate_save
    if LocationDestination.where({location_id:self.location_id,destination_id:self.destination_id}).count > 0
      errors.add(:location_id,'目的地已经存在')
    end
  end
end
