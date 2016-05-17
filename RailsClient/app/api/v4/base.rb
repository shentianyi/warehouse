#encoding: utf-8
module V4
  class Base < Grape::API
    include APIGuard
    version 'v4', :using => :path
    mount V4::StorageApi
  end
end