class CreateNStorages < ActiveRecord::Migration
  def change
    create_table :n_storages do |t|
      t.string :storageId
      t.string :part_nr
      t.datetime :fifo
      t.integer :qty
      t.string :position
      t.string :packageId
      t.string :uniqueId
      t.references :ware_house

      t.timestamps
    end
  end
end
