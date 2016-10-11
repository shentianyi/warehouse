class AddBatchNrToStorage < ActiveRecord::Migration
  def change
    add_column :n_storages, :extra_batch, :string
  end
end
