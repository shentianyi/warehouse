module V3
  class InventoryListApi < Grape::API
    namespace :inventory_list do
      format :json
      rescue_from :all do |e|
        Rack::Response.new([e.message], 500).finish
      end
      desc 'get processing data'
      get :processing do
        inventory_lists = InventoryList.where(state:200).all
        # if inventory_lists.size
        #   { result: 0, content: "没有查询到相关记录." }
        # else
          { result: 1, content: inventory_lists }
        # end
      end
    end
  end
end