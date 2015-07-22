class AddLockedToStorageAndInventoryItem < ActiveRecord::Migration
  def change
    add_column :n_storages, :locked, :boolean, default: false
    add_column :inventory_list_items,:locked,:boolean,default: false
  end
end
