class AddMovableColumnsToDeliveryForkliftAndPackages < ActiveRecord::Migration
  def change
    #add_to
    [:location_containers].each do |table|
      add_column table, :state, :integer, :default => 0

      [:current_location_id, :destination_id, :sender_id, :receiver_id].each { |c|
        add_column table, c, :string
        add_index table, c
      }

      [:delivery_date, :received_date].each { |c|
        add_column table, c, :datetime
      }
    end
  end
end
