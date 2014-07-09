class IsSysToUsers < ActiveRecord::Migration
  def change
    add_column :users,:is_sys,:boolean,:default => false
  end
end
