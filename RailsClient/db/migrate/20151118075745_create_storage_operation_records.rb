class CreateStorageOperationRecords < ActiveRecord::Migration
  def change
    create_table :storage_operation_records do |t|
      t.string :partNr
      t.string :qty
      t.string :fromWh
      t.string :fromPosition
      t.string :toWh
      t.string :toPosition
      t.string :packageId
      t.string :type_id
      t.string :remarks
      t.string :employee_id
      t.datetime :fifo

      t.timestamps
    end
  end
end
