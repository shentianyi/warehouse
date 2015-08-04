class AddInStoredToInventoryListItems < ActiveRecord::Migration
  def change
    add_column :inventory_list_items, :in_stored, :boolean,default: false
  end
end
