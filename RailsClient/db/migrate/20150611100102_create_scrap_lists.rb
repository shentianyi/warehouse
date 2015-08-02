class CreateScrapLists < ActiveRecord::Migration
  def change
    create_table :scrap_lists do |t|
      t.string :src_warehouse
      t.string :dse_warehouse
      t.string :builder

      t.timestamps
    end
  end
end
