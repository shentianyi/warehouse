class ChangePartIdTypeOfScrapListItems < ActiveRecord::Migration
  def change
    change_column :scrap_list_items,:part_id,:string
    change_column :scrap_list_items,:product_id,:string
  end
end
