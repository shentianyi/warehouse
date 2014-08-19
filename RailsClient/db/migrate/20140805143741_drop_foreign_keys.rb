class DropForeignKeys < ActiveRecord::Migration
  def change
    execute <<-SQL
ALTER TABLE deliveries
DROP FOREIGN KEY fk_deliveries_users,
DROP FOREIGN KEY fk_deliveries_sources,
DROP FOREIGN KEY fk_deliveries_destinations;
    SQL
    execute <<-SQL
ALTER TAbLE forklifts
DROP FOREIGN KEY fk_forklifts_deliveries,
DROP FOREIGN KEY fk_forklifts_stockers,
DROP FOREIGN KEY fk_forklifts_whouses,
DROP FOREIGN KEY fk_forklifts_users;
    SQL
    execute <<-SQL
 ALTER TABLE packages
DROP FOREIGN KEY fk_packages_locations,
DROP FOREIGN KEY fk_packages_parts,
DROP FOREIGN KEY fk_packages_users,
DROP FOREIGN KEY fk_packages_forklifts;
    SQL
    execute <<-SQL
 ALTER TABLE package_positions
DROP FOREIGN KEY fk_package_positions_positions,
DROP FOREIGN KEY fk_package_positions_packages
    SQL
  end
end
