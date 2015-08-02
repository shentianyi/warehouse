class ChangeColumnMigration < ActiveRecord::Migration
  def change
    change_column :n_storages, :qty, :decimal, precision: 9, scale: 2
    change_column :movements, :qty, :decimal, precision: 9, scale: 2
  end
end
