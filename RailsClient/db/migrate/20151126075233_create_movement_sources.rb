class CreateMovementSources < ActiveRecord::Migration
  def change
    create_table :movement_sources do |t|
      t.string :movement_list_id
      t.string :fromWh
      t.string :fromPosition
      t.string :packageId
      t.string :partNr
      t.float :qty
      t.datetime :fifo
      t.string :toWh
      t.string :toPosition
      t.string :employee_id
      t.string :remarks
      t.string :type

      t.timestamps
    end
  end
end
