class RemoveImplUserFromRecords < ActiveRecord::Migration
  def change
    remove_column :records,:impl_user
  end
end
