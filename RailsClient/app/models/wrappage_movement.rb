class WrappageMovement < ActiveRecord::Base
  validates_presence_of :package_type_id, :message => "包装物类型不能为空!"
  validates_presence_of :move_date, :message => "日期不能为空!"

  belongs_to :package_type
  belongs_to :user
  has_many :wrappage_movement_items, dependent: :destroy
end
