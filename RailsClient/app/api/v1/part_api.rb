module V1
  class PartAPI<Base
    namespace :parts do
      guard_all!
      post :validate do
        if PartService.validate_id params[:id], current_user
          {result: 1, content: ''}
        else
          {result: 0, content: '零件不存在！'}
        end
      end

      get :get_postion do

        wh_id=params[:wh_id].present? ? Whouse.nr_by_regex(params[:wh_id]) : SysConfigCache.default_warehouse_value
        if part = Part.find_by_id(Part.nr_by_regex( params[:part_id]))
          positions=part.positions.where(whouse_id: wh_id).pluck(:detail)
          if positions.size>0
            {result:1,content:positions}
          else
            {result:0,content:'没有找到对应库位！'}
          end
        else
          {result: 0,content: '零件号不存在！'}
        end
      end

      get :search_part do
        LedService.create_stockout_list('1001', 105)
      end

    end
  end
end