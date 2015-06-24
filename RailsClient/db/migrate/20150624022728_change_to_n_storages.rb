class ChangeToNStorages < ActiveRecord::Migration
  def change
    remove_column :n_storages, :qty, :integer
    add_column :n_storages, :qty, :decimal, precision: 9, scale: 2
  end
end
