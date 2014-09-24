class AddOrderIdsToPicklits < ActiveRecord::Migration
  def change
    add_column :pick_lists, :order_ids, :string
  end
end
