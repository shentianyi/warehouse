class AddLockBatchToNstorage < ActiveRecord::Migration
  def change
    add_column :n_storages, :lock_batch, :integer, default: 0
  end
end
