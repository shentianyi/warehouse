class AddBatchNrCloumnToStorage < ActiveRecord::Migration
  def change
    add_column :n_storages, :batch_nr, :string
  end
end
