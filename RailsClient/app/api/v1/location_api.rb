module V1
  class LocationAPI<Base
    namespace :locations
    guard_all!

    get :get_all do
      msg = ApiMessage.new
      data = []
      current_user.location.location_destinations.each do |l|
        data<<{name:l.destination.name,id:l.destination_id,is_default:l.is_default? ? 1:0}
      end
      data
    end

    get :warehouses do
      msg = ApiMessage.new
      data = []
      unless l = Location.find_by_id(params[:id])
        return msg.set_false(LocationMessage::NotFound)
      end

      l.whouses.each{|w|
        data<<{id:w.id,name:w.name}
      }
      data
    end
  end
end