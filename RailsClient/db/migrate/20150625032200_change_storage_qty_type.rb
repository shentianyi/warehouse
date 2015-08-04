class ChangeStorageQtyType< ActiveRecord::Migration
  def change
    change_column :n_storages, :qty, :decimal, precision: 20, scale: 10
    change_column :movements, :qty, :decimal, precision: 20, scale: 10
  end
end
