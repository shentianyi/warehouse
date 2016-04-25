class AddRemarksToNStorages < ActiveRecord::Migration
  def change
    add_column :n_storages, :remarks, :string
  end
end
