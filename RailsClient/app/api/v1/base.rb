module V1
  class Base < ApplicationAPI
    include APIGuard
    version 'v1', :using => :path
    mount UserAPI
  end
end
