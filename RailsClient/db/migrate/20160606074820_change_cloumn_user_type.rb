class ChangeCloumnUserType < ActiveRecord::Migration
  def change
    change_column :wrappage_movements,:user_id,:string, :limit => 36
  end
end
