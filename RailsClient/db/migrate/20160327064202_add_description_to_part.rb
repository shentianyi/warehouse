class AddDescriptionToPart < ActiveRecord::Migration
  def change
    add_column :parts, :description, :string
  end
end
