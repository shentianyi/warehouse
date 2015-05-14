class CreateNLocations < ActiveRecord::Migration
  def change
    create_table :n_locations do |t|
      t.string :locationId
      t.string :name
      t.string :remark, default: ''
      t.integer :status, default: 0
      t.references :parent, index: true

      t.timestamps
    end
    add_index 'n_locations', ['locationId'], :name => "location_id_unique", :unique => true
  end
end
