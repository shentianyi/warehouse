class InventoryListItem < ActiveRecord::Base
  belongs_to :package
  belongs_to :part
  belongs_to :position
  belongs_to :user
  belongs_to :inventory_list
  
  validates :part_id, :qty, :inventory_list_id, presence: true
  validates_inclusion_of :in_store, in: [true, false]
  
end
