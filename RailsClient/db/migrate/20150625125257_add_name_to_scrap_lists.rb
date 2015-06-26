class AddNameToScrapLists < ActiveRecord::Migration
  def change
    add_column :scrap_lists, :name, :string
  end
end
