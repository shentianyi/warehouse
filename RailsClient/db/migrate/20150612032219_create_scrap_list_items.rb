class CreateScrapListItems < ActiveRecord::Migration
  def change
    create_table :scrap_list_items do |t|
      t.integer :scrap_list_id
      t.integer :part_id
      t.integer :product_id
      t.integer :quantity
      t.string :IU
      t.string :reason
      t.string :name
      t.datetime :time

      t.timestamps
    end
  end
end
