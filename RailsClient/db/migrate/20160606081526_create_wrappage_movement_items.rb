class CreateWrappageMovementItems < ActiveRecord::Migration
  def change
    create_table :wrappage_movement_items do |t|
      t.string :src_location_id
      t.string :des_location_id
      t.integer :qty
      t.integer :wrappage_move_type_id
      t.references :user, index: true
      t.string :sourceable_id
      t.string :sourceable_type
      t.string :extra_800_nos
      t.string :extra_leoni_out_no
      t.integer :wrappage_movement_id

      t.timestamps
    end

    add_index :wrappage_movement_items, :sourceable_id
    add_index :wrappage_movement_items, :sourceable_type
    add_index :wrappage_movement_items, :src_location_id
    add_index :wrappage_movement_items, :des_location_id
    add_index :wrappage_movement_items, :wrappage_move_type_id
    add_index :wrappage_movement_items, :wrappage_movement_id
  end
end
