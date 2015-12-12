class AddRemarkToInventoryListItems < ActiveRecord::Migration
  def change
    add_column :inventory_list_items, :remark, :string
  end
end
