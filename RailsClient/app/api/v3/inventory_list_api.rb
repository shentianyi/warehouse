module V3
  class InventoryListApi < Base
    namespace :inventory_list do
      guard_all!

      format :json
      rescue_from :all do |e|
        Rack::Response.new([e.message], 500).finish
      end
      desc 'get processing data'
      get :processing do
        inventory_lists = InventoryList.where(state: 200).all
        # if inventory_lists.size
        #   { result: 0, content: "没有查询到相关记录." }
        # else
        {result: 1, content: inventory_lists}
        # end
      end

      desc 'get inventory list item positions api'
      params do
        optional :position, type: String
        requires :inventory_list_id, type: Integer, desc: 'inventory list id'
        requires :user_id, type: String, desc: 'inventory list item builder'
      end
      get :inventory_list_position do
        params[:page] = 0 if params[:page].blank? || params[:page].to_i < 0
        params[:size] = 30 if params[:size].blank? || params[:size].to_i < 0

        if params[:position] && Position.find_by(detail: params[:position]).blank?
          msg= {result_code: 0, msg: "库位#{params[:position]}不存在"}
          return msg
        end

        msg = InventoryListItem.condition_positions params
        if msg.result
          {
              result_code: '1',
              msg: msg.content
          }
        else
          {
              result_code: '0',
              msg: ['there is no data in the request']
          }
        end
      end

    end
  end
end