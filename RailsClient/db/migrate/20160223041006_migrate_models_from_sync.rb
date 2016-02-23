class MigrateModelsFromSync < ActiveRecord::Migration
  def up
    #user
    rename_column :users, :user_name, :nr

    # location
    add_column :locations, :nr, :string
    add_index :locations, :nr


    # warehouse
    add_column :whouses, :nr, :string
    add_index :whouses, :nr


    # position
    add_column :positions, :nr, :string
    add_index :positions, :nr

    # part_types
    add_column :part_types, :nr, :string
    add_index :part_types, :nr

    # part
    add_column :parts, :nr, :string
    add_index :parts, :nr

    # change_column :users,:location_id,:integer
    #
    # # delete sync fields
    # [:users, :locations].each do |m|
    #   remove_column m, :is_delete
    #   remove_column m, :is_dirty
    #   remove_column m, :is_new
    # end
  end

  def down
    rename_column :users, :nr, :user_name
    remove_index :locations, :nr
    remove_column :locations, :nr

    remove_index :whouses, :nr
    remove_column :whouses, :nr

    remove_index :positions, :nr
    remove_column :positions, :nr

    remove_index :part_types, :nr
    remove_column :part_types, :nr

    remove_index :parts, :nr
    remove_column :parts, :nr


    # [:users, :locations].each do |m|
    #   add_column m, :is_delete, :boolean, :default => false
    #   add_column m, :is_dirty, :boolean, :default => true
    #   add_column m, :is_new, :boolean, :default => true
    # end
  end
end
