class CreateMovements < ActiveRecord::Migration
  def change
    create_table :movements do |t|
      t.string :partnr
      t.datetime :fifo
      t.integer :qty
      t.integer :from
      t.string :from_position
      t.integer :from
      t.string :to_position
      t.string :packageId
      t.string :uniqueId
      t.integer :type_id

      t.timestamps
    end
  end
end
