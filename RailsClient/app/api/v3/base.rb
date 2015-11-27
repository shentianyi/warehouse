#encoding: utf-8
module V3
  class Base < Grape::API
    include APIGuard
    version 'v3', :using => :path
    mount V3::WareHouseApi
    mount V3::LocationApi
    mount V3::InventoryListApi
    mount V3::InventoryListItemApi
    mount V3::MovementListApi
    mount V3::MovementApi
    mount V3::MovementSourceApi
  end
end