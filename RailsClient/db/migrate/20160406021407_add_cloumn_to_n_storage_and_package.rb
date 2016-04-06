class AddCloumnToNStorageAndPackage < ActiveRecord::Migration
  def change
    add_column :n_storages, :supplier, :string
    add_column :containers, :supplier, :string
  end
end
