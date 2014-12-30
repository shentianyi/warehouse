module V2
  class Base < ApplicationAPI
    include APIGuard
    version 'v2', :using => :path
    mount UserSessionsAPI
  end
end