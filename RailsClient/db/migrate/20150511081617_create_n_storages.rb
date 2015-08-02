class CreateNStorages < ActiveRecord::Migration
  def change
    create_table :n_storages do |t|
      t.string :storageId
      t.string :partNr
      t.datetime :fifo
      t.integer :qty
      t.string :position
      t.string :packageId
      t.string :uniqueId
      t.references :ware_house, index: true

      t.timestamps
    end
    add_index 'n_storages', ['storageId'], :name => "storage_id_unique", :unique => true
    add_index 'n_storages', ['packageId'], :name => "package_id_index"
    add_index 'n_storages', ['uniqueId'], :name => "unique_id_unique", :unique => true
  end
end
