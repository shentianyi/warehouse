#encoding: utf-8
module V3
  class Base < Grape::API
    include APIGuard
    version 'v3', :using => :path
    mount V3::LocationApi
  end
end