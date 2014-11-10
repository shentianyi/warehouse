class AddMovableColumnsToLocationContainers < ActiveRecord::Migration
  def change
    [:location_containers].each do |table|
      add_column table, :state, :integer, :default => 0

      [:current_positionable_id,:current_positionable_type,
       :sourceable_id,:sourceable_type,
       :destinationable_id,:destinationable_type,
       :sender_id, :receiver_id].each { |c|
        add_column table, c, :string
        add_index table, c
      }

      [:delivery_date, :received_date].each { |c|
        add_column table, c, :datetime
      }
    end
  end
end
