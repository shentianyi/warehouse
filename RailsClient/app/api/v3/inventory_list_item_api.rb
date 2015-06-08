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
        
        @package_id = ""
        @unique_id = ""
        # 此处由于model中 InventListItem表设计要求part_id不能为空，故强行赋一个默认值？
        @part_id = "411140015"
        
        # 根据参数组合情况获取nstorage start
        if params[:package_id].present?
          @package_id = params[:package_id]
          query = NStorage.find_by(packageid: params[:package_id])
        elsif params[:unique_id].present?
          @unique_id = params[:unique_id]
          query = NStorage.find_by(uniqueid: params[:unique_id])
        elsif params[:part_id].present?
          @part_id = params[:part_id]
          query = NStorage.find_by(partNr: params[:part_id])
        else
          query = nil
        end
        # 根据参数组合情况获取nstorage end
        
        @qty = params[:qty].nil? ? 0 : params[:qty]
        @position = params[:position].nil? ? "" : params[:position]
        @inventory_list_id = params[:inventory_list_id].nil? ? 1 : params[:inventory_list_id]
        @user_id = "admin"
        
        if query.blank?
          # 未入库，直接生成
          @current_whouse = nil
          @current_position = nil
          @in_store = false
        else
          # 已入库，参数组合生成
          @current_whouse = query.ware_house_id
          @current_position = query.position
          @in_store = true
        end
        
        # 赋值
        inventory_list_item = InventoryListItem.new(:package_id => @package_id,:unique_id => @unique_id,
        :part_id => @part_id,:qty => @qty,:position => @position,:current_whouse => @current_whouse,
        :current_position => @current_position,:user_id => @user_id,:in_store => @in_store,
        :inventory_list_id => @inventory_list_id)
        
        # 保存
        if inventory_list_item.save
          if inventory_list_item.in_store
            {result: 1, content: inventory_list_item}
          else
            {result: 1, content: "未入库"}
          end
        else
          {result: 0, content: "添加Item失败"}
        end
        
      end
    end
  end
end