class CreatePackageTypes < ActiveRecord::Migration
  def change
    create_table :package_types do |t|
      t.string :nr, index: true
      t.string :name

      t.timestamps
    end
  end
end
