class CreateInventoryLists < ActiveRecord::Migration
  def change
    create_table :inventory_lists do |t|
      t.string :name
      t.integer :state, :default => 100
      t.string :whouse_id
      t.string :user_id

      t.timestamps
    end
  end
end
