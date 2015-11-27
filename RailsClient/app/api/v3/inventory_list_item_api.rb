module V3
  class InventoryListItemApi < Base
    namespace :inventory_list_item do
      guard_all!

      format :json
      rescue_from :all do |e|
        Rack::Response.new([e.message], 500).finish
      end

      desc 'get processing data'
      get :processing do
        p = InventoryListItem.all
        {result: 1, content: p}
      end

      desc 'Create InventoryListItem.'
      params do
        optional :package_id, type: String
        optional :unique_id, type: String
        optional :part_id, type: String
        optional :qty, type: String, desc: 'require qty(quantity)'
        requires :position, type: String
        requires :inventory_list_id, type: Integer
      end
      post do
        puts '-----------'
        puts params.to_json
        puts '-----------'
        msg=nil
        query = NStorage
        # query relation params

        package_id = params[:package_id].nil? ? nil : params[:package_id]
        unique_id = params[:unique_id].nil? ? nil : params[:unique_id]
        part_id = params[:part_id].nil? ? nil : params[:part_id].sub(/^P/,'')
        qty = params[:qty].nil? ? nil : params[:qty].sub(/^Q/,'')

        position = params[:position].nil? ? nil : params[:position]
        inventory_list_id = params[:inventory_list_id].nil? ? nil : params[:inventory_list_id]
        user_id = current_user.id

        if package_id.nil? && qty.nil?
          msg= {result: 0, content: "请填写数量！"}
          return msg
        end
        if Position.find_by(detail: position).blank?
          msg= {result: 0, content: "库位#{position}不存在"}
          return msg
        end

        if InventoryList.find_by(id: inventory_list_id).blank?
          msg= {result: 0, content: "盘点单号#{inventory_list_id}不存在"}
          return msg
        end

        if part_id && Part.find_by(id: part_id).blank?
          msg= {result: 0, content: "零件号#{part_id}不存在"}
          return msg
        end

        begin
          # 保存
          item={
              package_id:package_id,
              unique_id:unique_id,
              part_id:part_id,
              qty:qty,
              position:position,
              inventory_list_id:inventory_list_id,
              user_id:user_id,
              need_convert:false
          }

          msg = FileHandler::Excel::InventoryListItemHandler.validate_api_params item
          unless msg.result
            return {result: 0, content: msg.content}
          end
          inventory_list_item = InventoryListItem.new_item(item)
          if inventory_list_item.blank?
            msg= {result: 0, content: '添加失败'}
          else
            if inventory_list_item.in_store || inventory_list_item.package_id.blank?
              msg= {result: 1, content: '生成成功'}
            else
              msg= {result: 2, content: '生成成功，未入库'}
            end
          end
        rescue => e
          puts e.message
          msg={result: 0, content: e.message}
        end
        puts "#{msg}......"
        msg
      end

      desc 'get inventory list items by positions api'
      params do
        requires :inventory_list_id, type: Integer, desc: 'inventory list id'
        requires :user_id, type: String, desc: 'inventory list item builder'
        requires :position, type: String, desc: 'inventory list item position'
      end
      get :inventory_item_list do
        params[:page] = 0 if params[:page].blank? || params[:page].to_i < 0
        params[:size] = 30 if params[:size].blank? || params[:size].to_i < 0

        if Position.find_by(detail: params[:position]).blank?
          msg= {result: 0, content: "库位#{params[:position]}不存在"}
          return msg
        end

        msg = InventoryListItem.condition_items params
        if msg.result
          {
              result: '1',
              content: msg.content
          }
        else
          {
              result: '0',
              content: ['there is no data in the request']
          }
        end
      end

      desc 'delete inventory list item api'
      params do
        requires :inventory_list_item_id, type: Integer, desc: 'inventory list id'
      end
      delete do
        unless item = InventoryListItem.find_by(id: params[:inventory_list_item_id])
          return {result: 0, content: InventoryListItemMessage::NotFound}
        end

        begin
          item.destroy
        rescue => e
          return {result: 0, content: e.message}
        end
        return {result: 1, content: InventoryListItemMessage::DeleteSuccess}
      end


      desc 'Update InventoryListItem.'
      params do
        optional :package_id, type: String
        requires :part_id, type: String
        requires :qty, type: String, desc: 'require qty(quantity)'
        requires :whouse_id, type: String
        requires :position, type: String
        requires :inventory_list_item_id, type: Integer
      end
      post :data_update do
        unless item = InventoryListItem.find_by(id: params[:inventory_list_item_id])
          return {result: 0, content: InventoryListItemMessage::NotFound}
        end

        args = {}
        args[:package_id] = params[:package_id] unless params[:package_id].blank?
        args[:part_id] = params[:part_id] unless params[:part_id].blank?
        args[:qty] = params[:qty] unless params[:qty].blank?
        args[:whouse_id] = params[:whouse_id] unless params[:whouse_id].blank?
        args[:position] = params[:position] unless params[:position].blank?

        begin
          item.update(args)
        rescue => e
            return {result: 0, content: e.message}
        end
        return {result: 1, content: InventoryListItemMessage::UpdateSuccess}

      end

    end
  end
end