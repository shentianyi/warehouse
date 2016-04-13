class CreateLocationContainerPickLists < ActiveRecord::Migration
  def change
    create_table :location_container_pick_lists do |t|
      t.string :location_container_id
      t.string :pick_list_id

      t.timestamps
    end
  end
end
