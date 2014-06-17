class RemoveUserNoFromUsers < ActiveRecord::Migration
  def change
    remove_index :users, :user_no
    remove_column :users, :user_no
  end
end
