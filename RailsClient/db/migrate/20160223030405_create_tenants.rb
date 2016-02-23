class CreateTenants < ActiveRecord::Migration
  def change
    create_table :tenants do |t|
      t.string :name
      t.string :code
      t.string :address
      t.string :email
      t.string :tel
      t.string :website
      t.integer :type

      t.timestamps
    end
  end
end
