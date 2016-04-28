#encoding: utf-8
module V3
  class PickListApi < Base
    guard_all!
    namespace :pick_lists do
      format :json
      rescue_from :all do |e|
        Rack::Response.new([e.message], 500).finish
      end

      params do
        requires :id, type: String, desc: 'pick list id'
      end
      get do
        if pick=PickList.find_by_id(params[:id])
          {
              result: 1,
              content: PickListPresenter.new(pick).to_json
          }
        else
          {result: 0, content: "择货单不存在!"}
        end
      end
    end
  end
end