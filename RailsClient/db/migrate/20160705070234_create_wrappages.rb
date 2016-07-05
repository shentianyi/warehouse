class CreateWrappages < ActiveRecord::Migration
  def change
    create_table :wrappages do |t|
      t.string :nr
      t.string :name
      t.string :desc
      t.string :mirror_id

      t.timestamps
    end
  end
end
