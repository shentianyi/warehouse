class PickList < ActiveRecord::Base
  include Extensions::UUID
  belongs_to :user
  has_many :pick_items, dependent: :destroy

  has_many :delivery_pick_lists, dependent: :destroy
  has_many :deliveries, through: :delivery_pick_lists

  def generate_id
    "P#{Time.now.to_milli}"
  end
end
