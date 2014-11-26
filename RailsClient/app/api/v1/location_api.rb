module V1
  class LocationAPI<Base
    namespace :locations
    guard_all!

    get :get_destinations do
      msg = ApiMessage.new
      data = []
      Location.list.each do |l|
        data<<{name:l.name,id:l.id,is_default:(l.id == current_user.location_id ? 1 : 0)}
      end
      data
    end
  end
end