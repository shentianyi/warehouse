module V1
  class ForkliftAPI<Base
    namespace :forklifts
    guard_all!

    # get binded but not add to delivery forklifts
    get :binds do
      forklifts = ForkliftService.avaliable_to_bind
      data = []
      forklifts.all.each do |f|
        data<<{id:f.id,created_at:f.created_at,user_id:f.user_id,whouse_id:f.whouse_id}
      end
      data
    end

    # create forklift
    post do

    end


    # check package
    post :check_package do

    end

    # add package
    post :add_package do

    end

    # remove package
    # id is forklift_item_id
    delete :remove_package do

    end

    #delete forklift
    delete do

    end

    # get forklift detail
    get :detail do

    end

    # update forklift
    patch do

    end
  end
end