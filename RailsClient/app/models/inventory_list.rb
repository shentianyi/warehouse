class InventoryList < ActiveRecord::Base
  belongs_to :user
  belongs_to :whouse
  validates :name, presence: true
end
