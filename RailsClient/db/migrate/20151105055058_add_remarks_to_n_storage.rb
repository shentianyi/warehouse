class AddRemarksToNStorage < ActiveRecord::Migration
  def change
    add_column :n_storages,:remarks,:text
  end
end
