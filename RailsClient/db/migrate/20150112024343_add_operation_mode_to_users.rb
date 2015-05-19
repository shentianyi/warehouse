class AddOperationModeToUsers < ActiveRecord::Migration
  def change
    add_column :users,:operation_mode,:integer, :default => 0
  end
end
