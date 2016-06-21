class CreateWrappageMovements < ActiveRecord::Migration
  def change
    create_table :wrappage_movements do |t|
      t.date :move_date
      t.references :package_type, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
