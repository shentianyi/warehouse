class CreateSyncPools < ActiveRecord::Migration
  def change
    create_table :sync_pools do |t|
      t.string :table_name
      t.boolean :locked
      t.string :client_ip

      t.timestamps
    end
  end
end
