module V1
  class PackageAPI<Base
    namespace :packages
    guard_all!

    # get binded but not add to forklift packages
    get :binds do

    end

    # validate package id
    post :validate do

    end

    # create package
    # if find deleted then update(take care of foreign keys)
    # else create new
    post do

    end

    # update package
    patch do

    end

    # delete package
    # update is_delete to true
    delete do

    end
  end
end