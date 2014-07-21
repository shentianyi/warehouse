class OrderItem < ActiveRecord::Base
	include Extensions::UUID

	belongs_to :order
	belongs_to :user
	belogns_to :locations
	belongs_to :whouse
	belongs_to :supplier, class_name: "Location"
	belongs_to :part
	belongs_to :part_type
end
