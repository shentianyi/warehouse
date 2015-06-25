class InventoryList < ActiveRecord::Base
  belongs_to :user
  belongs_to :whouse
  has_many :inventory_list_items,dependent: :destroy
  validates :name, presence: true
  validates :state, presence: true
end
