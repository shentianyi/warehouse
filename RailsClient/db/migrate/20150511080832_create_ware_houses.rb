class CreateWareHouses < ActiveRecord::Migration
  def change
    create_table :ware_houses do |t|
      t.string :whId
      t.string :name
      t.references :location, index: true
      t.string :positionPattern, default: ''

      t.timestamps
    end
    add_index 'ware_houses', ['whId'], :name => "wh_id_unique", :unique => true
  end
end
