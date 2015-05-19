class SyncLog < ActiveRecord::Migration
  def change
    create_table :sync_logs do |t|
      t.string :table_name
      t.boolean :sync, default: false

      t.timestamps
    end
  end
end
