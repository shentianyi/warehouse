class CreateDockPoints < ActiveRecord::Migration
  def change
    create_table :dock_points do |t|
      t.string :nr
      t.string :desc

      t.timestamps
    end
  end
end
