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
  end
end