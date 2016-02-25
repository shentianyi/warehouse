class CreatePartClients < ActiveRecord::Migration
  def change
    create_table :part_clients do |t|
      t.references :part, index: true
      t.string :client_part_nr
      t.integer :client_tenant_id

      t.timestamps
    end
  end
end
