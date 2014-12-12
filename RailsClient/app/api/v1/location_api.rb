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
        #return msg.set_false(LocationMessage::NotFound)
        return []
      end

      l.whouses.each{|w|
        data<<{id:w.id,name:w.name}
      }
      data
    end

    get :test do
      msg = ApiMessage.new
      model = params[:model].constantize
      if params[:skip] && params[:skip].to_i == 1
        puts "-----------#{model} skip_callbacks"
        model.record_timestamps=false
        model.skip_callback(:update, :before, :reset_dirty_flag)
        model.skip_callback(:create,:before,:init_container_attr)
      else
        puts "-----------#{model} reset_callbacks"
        model.record_timestamps=true
        model.set_callback(:update, :before, :reset_dirty_flag)
        model.set_callback(:create,:before,:init_container_attr)
      end
      msg
    end
  end
end