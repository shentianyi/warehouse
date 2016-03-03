class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string :name
      t.string :value
      t.string :code
      t.integer :type

      t.timestamps
    end
  end
end
