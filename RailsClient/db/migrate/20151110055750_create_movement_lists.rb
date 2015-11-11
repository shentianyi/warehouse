class CreateMovementLists < ActiveRecord::Migration
  def change
    create_table :movement_lists do |t|
      t.string :name, :default => ''
      t.string :state, :default => 100
      t.string :builder
      t.string :remarks, :default => ''

      t.timestamps
    end
  end
end
