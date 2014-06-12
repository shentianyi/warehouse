class AddLocationToDeliveies < ActiveRecord::Migration
  def change
    add_column :deliveries, :source_id ,:string
    add_column :deliveries, :destination_id ,:string


    reversible do |dir|
      dir.up do
        execute <<-SQL
        ALTER TABLE deliveries
ADD CONSTRAINT fk_deliveries_sources
FOREIGN KEY (source_id)
REFERENCES locations(id),
ADD CONSTRAINT fk_deliveries_destinations
FOREIGN KEY (destination_id)
REFERENCES locations(id)
        SQL
      end

      dir.down do
        execute <<-SQL
        ALTER TABLE deliveries
DROP FOREIGN KEY fk_deliveries_sources,
DROP FOREIGN KEY fk_deliveries_destinations
        SQL
      end
    end
    add_index :deliveries, :source_id
    add_index :deliveries, :destination_id
  end
end
