class InventoryListItem < ActiveRecord::Base
  belongs_to :package
  belongs_to :part
  belongs_to :position
  belongs_to :user
  belongs_to :inventory_list
end
