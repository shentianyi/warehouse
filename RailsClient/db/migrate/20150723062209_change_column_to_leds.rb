class ChangeColumnToLeds < ActiveRecord::Migration
  def change
    rename_column :leds, :position, :position_id
  end
end
