class CreateInventoryListItems < ActiveRecord::Migration
  def change
    create_table :inventory_list_items do |t|
      t.string :package_id
      t.string :unique_id
      t.string :part_id
      t.float :qty
      t.string :position
      t.string :current_whouse
      t.string :current_position
      t.string :user_id
      t.boolean :in_store, :default => false
      t.integer :inventory_list_id

      t.timestamps
    end
  end
end
