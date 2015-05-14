class CreateMoveTypes < ActiveRecord::Migration
  def change
    create_table :move_types do |t|
      t.string :typeId
      t.string :short_desc
      t.text :long_desc

      t.timestamps
    end
  end
end
