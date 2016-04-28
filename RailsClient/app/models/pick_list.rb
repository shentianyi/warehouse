class PickList < ActiveRecord::Base
  include Extensions::UUID
  belongs_to :user
  has_many :pick_items, dependent: :destroy

  has_many :location_container_pick_lists, dependent: :destroy
  has_many :location_containers, through: :location_container_pick_lists


  def generate_id
    "P#{Time.now.to_milli}"
  end
end
