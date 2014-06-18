class RemoveUserNoFromUsers < ActiveRecord::Migration
  def change
    remove_index :users, :user_no
    remove_column :users, :user_no
    remove_column :packages, :in_date
  end
end
