#encoding: utf-8
module V3
  class Base < Grape::API
    include APIGuard
    version 'v4', :using => :path
    mount V4::OrderCarAPI
    mount V4::OrderBoxAPI
    mount V4::UserAPI
    mount V4::OrderAPI
    mount V4::PickAPI
    mount V4::PickItemAPI
    mount V4::WarehouseAPI
  end
end