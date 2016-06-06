class WrappageMovementItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :wrappage_movement
  belongs_to :src_location, class_name: 'Location'
  belongs_to :des_location, class_name: 'Location'

  belongs_to :sourceable, polymorphic: true
end
