class CreateNLocations < ActiveRecord::Migration
  def change
    create_table :n_locations do |t|
      t.string :locationId
      t.string :name
      t.string :remark
      t.integer :status
      t.integer :parent_id

      t.timestamps
    end
  end
end
