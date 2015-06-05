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
        # inventory_items = InventoryItem.find_by_state(200)
        # { result: 1, content: inventory_lists }
        { result: 1, content: p }
      end
      
      desc 'Add InventoryListItem.'
      params do
        optional :packageId, type: String
        optional :uniqueId, type: String
        optional :partId, type: String
        optional :qty, type: Float, desc: 'require qty(quantity)'
        requires :position, type: String
        requires :inventorylistId, type: Integer
      end
      post :add do
        puts params.to_json
        query = NStorage
        # query relation params
        if params[:packageId].present? && params[:position].present?
          query = NStorage.find_by(packageid: params[:packageId])
          #query = query.joins(:ware_house).where(Whouse.arel_table[:whId].eq(params[:whId]))
          if query.blank?
            ex="找不到packageid对应记录"
            {result: 1, content: ex}
          else
            #添加
            puts query.position
            s = InventoryListItem.new
            s.package_id = params[:packageId]
            s.unique_id = "1"
            s.part_id = "1"
            s.qty = "1"
            s.position = params[:position]
            #s.position = "1"
            # s.position = Position.find_by(id: params[:position])
            #s.position = query.position
            #s.position = 3Floor
            s.current_whouse = query.ware_house_id
            #s.current_position = query.position
            s.current_position = query.position
            # s.current_position = "1"
            s.user_id = "1"
            s.in_store = true
            s.inventory_list_id = params[:inventorylistId]
            if s.save
              ex="添加Item成功"
              {result: 1, content: ex}
            else
              ex="添加Item失败"
              {result: 0, content: ex}
            end
          end
        else
          ex="未入库"
          {result: 1, content: ex}
        end
        # if params[:fromWh].present?
#
#         s = InventoryListItem.new(params)
#         #s.user_id = current_user.id
#         if s.save
#           {result: 1, content: s}
#         # s=WhouseService.new.enter_stock(params)
#         else
#           ex="未入库"
#           {result: 1, content: ex}
#         end
      end
      
    end
  end
end