class AddPickedCountToPickItem < ActiveRecord::Migration
  def change
    add_column :pick_items, :picked_count, :integer, default: 0
  end
end
