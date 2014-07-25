class OrderItem < ActiveRecord::Base
	include Extensions::UUID

	belongs_to :order
	belongs_to :user
  belongs_to :location
	belongs_to :whouse
	belongs_to :source, class_name: "Location"
	belongs_to :part
	belongs_to :part_type

  def generate_id
    "OI#{Time.now.to_milli}"
  end
end
