class CreateOperationLogs < ActiveRecord::Migration
  def change
    create_table :operation_logs do |t|
      t.string :item_type
      t.string :item_id
      t.string :event
      t.string :whodunnit
      t.text :object

      t.timestamps
    end
  end
end
