class AddCheckInTimeToPackages < ActiveRecord::Migration
  def change
    add_column :packages, :check_in_time, :string
  end
end
