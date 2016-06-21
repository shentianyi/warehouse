class ChangeCloumnUserTypeToWrappageMoveItem < ActiveRecord::Migration
  def change
    change_column :wrappage_movement_items,:user_id,:string, :limit => 36
  end
end
