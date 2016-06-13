class WrappageMovementItem < ActiveRecord::Base
  validates_presence_of :src_location_id, :message => "发出地不能为空!"
  validates_presence_of :des_location_id, :message => "接收地不能为空!"

  belongs_to :user
  belongs_to :wrappage_movement
  belongs_to :src_location, class_name: 'Location'
  belongs_to :des_location, class_name: 'Location'

  belongs_to :sourceable, polymorphic: true
end
