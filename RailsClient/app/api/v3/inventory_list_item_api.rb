module V3
  class InventoryListItemApi < Grape::API
    namespace :inventory_list_item do
      format :json
      rescue_from :all do |e|
        Rack::Response.new([e.message], 500).finish
      end
      
      desc 'get processing data'
      get :processing do
        p = InventoryListItem.all
        { result: 1, content: p }
      end
      
      desc 'Create InventoryListItem.'
      params do
        optional :package_id, type: String
        optional :unique_id, type: String
        optional :part_id, type: String
        optional :qty, type: Float, desc: 'require qty(quantity)'
        requires :position, type: String
        requires :inventory_list_id, type: Integer
      end
      post do
        puts params.to_json
        query = NStorage
        # query relation params
        
        package_id = params[:package_id].nil? ? nil : params[:package_id]
        unique_id = params[:unique_id].nil? ? nil : params[:unique_id]
        part_id = params[:part_id].nil? ? nil : params[:part_id]
        qty = params[:qty].nil? ? nil : params[:qty]
        
        position = params[:position].nil? ? nil : params[:position]
        inventory_list_id = params[:inventory_list_id].nil? ? nil : params[:inventory_list_id]
        user_id = current_user.id
        
        # 保存
        inventory_list_item = InventoryListItem.new_item(package_id, unique_id, part_id, qty, position, inventory_list_id, user_id)
        if inventory_list_item.blank?
          {result: 0, content: "添加Item失败"}
        else
          if inventory_list_item.in_store
            {result: 1, content: inventory_list_item}
          else
            {result: 1, content: "未入库"}
          end
        end
      end
    end
  end
end