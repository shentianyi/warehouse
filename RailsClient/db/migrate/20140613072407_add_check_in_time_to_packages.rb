class AddCheckInTimeToPackages < ActiveRecord::Migration
  def change
    add_column :packages, :check_in_time, :datetime
    add_column :packages, :check_in_time_str, :string
  end
end
