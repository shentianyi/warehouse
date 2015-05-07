class ChangeOrderIdsOfPickLists < ActiveRecord::Migration
  def change
    change_column :pick_lists, :order_ids, :text, :limit => nil
  end
end
