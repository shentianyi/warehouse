class CreateMovements < ActiveRecord::Migration
  def change
    create_table :movements do |t|
      t.string :partnr
      t.datetime :fifo
      t.integer :qty
      t.references :from
      t.string :from_position
      t.references :to
      t.string :to_position
      t.string :packageId
      t.string :uniqueId
      t.references :type, index:true

      t.timestamps
    end
    add_index 'movements', ['packageId'], :name => "package_id_unique", :unique => true
    add_index 'movements', ['uniqueId'], :name => "unique_id_unique", :unique => true
  end
end
