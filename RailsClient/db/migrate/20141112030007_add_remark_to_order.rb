class AddRemarkToOrder < ActiveRecord::Migration
  def change
    add_column :orders,:remark,:text
    add_column :pick_lists,:remark,:text
  end
end
