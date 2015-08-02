class ChangeCloumnTypeOfStoragesAndMovements < ActiveRecord::Migration
  def change
    change_column :n_storages,:ware_house_id,:string
    change_column :movements,:from_id,:string
    change_column :movements,:to_id,:string
  end
end
