class AddMovableColumnsToDeliveryForkliftAndPackages < ActiveRecord::Migration
  # def change
  #   #add_to
  #   [:deliveries,:forklifts,:packages].each do |table|
  #     [:current_location_id,:destination_id,:sender_id,:receiver_id].each{|c|
  #       unless column_exists? table,c
  #         add_column table,c,:string
  #       end
  #
  #       unless index_exists? table,c
  #         add_index table,c
  #       end
  #     }
  #
  #     [:delivery_date,:received_date].each{|c|
  #       unless column_exists? table,c
  #         add_column table,c,:datetime
  #       end
  #     }
  #   end
  # end
end
