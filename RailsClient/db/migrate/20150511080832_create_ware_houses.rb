class CreateWareHouses < ActiveRecord::Migration
  def change
    create_table :ware_houses do |t|
      t.string :whId
      t.string :name
      t.integer :location_id
      t.string :position_pattern

      t.timestamps
    end
  end
end
