class AddBackTimeCloumnToBackPart < ActiveRecord::Migration
  def change
    add_column :back_parts, :back_time, :datetime
  end
end
