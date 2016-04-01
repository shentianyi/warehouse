class AddLockFieldsToNStorages < ActiveRecord::Migration
  def change
    add_column :n_storages, :lock_user_id, :string
    add_column :n_storages, :lock_remark, :string
    add_column :n_storages, :lock_at, :timestamp
    add_index :n_storages, :locked
  end
end
