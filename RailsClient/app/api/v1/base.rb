module V1
  class Base < ApplicationAPI
    include APIGuard
    version 'v1', :using => :path
    mount UserAPI
    mount PackageAPI
    mount PartAPI
    mount ForkliftAPI
    mount DeliveryAPI
  end
end
