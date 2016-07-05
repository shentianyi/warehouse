class CreatePartWrappages < ActiveRecord::Migration
  def change
    create_table :part_wrappages do |t|
      t.string :part_id
      t.integer :wrappage_id
      t.integer :capacity

      t.timestamps
    end
  end
end
