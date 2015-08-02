class AddPositionPatternToWhouses < ActiveRecord::Migration
  def change
    add_column :whouses, :position_pattern, :string,default: ''
  end
end
