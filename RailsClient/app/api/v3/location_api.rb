#encoding: utf-8
module V3
  class LocationApi < Grape::API
    namespace :location do
      format :json
      rescue_from :all do |e|
        Rack::Response.new([e.message], 500).finish
      end

      helpers do
        def validate_position_pattern(pattern)
          # TODO:
        end
      end

      get do
        # guard!
        locations = Location.all
        {result: 1, content: locations}
      end

      params do
        requires :locationId, type: String, desc: 'require locationId'
        requires :name, type: String, desc: 'require Location name'
        optional :remark, type: String, desc: 'require remark of Location'
        # requires :parentId, type: String, desc: 'require parentId'
        optional :status, type: String, desc: 'require status'
      end
      post do
        # validate locationId
        # find the parent by id, not parent id -by charlot
        parent = params[:parentId].present? ? Location.find_by!(id: params[:parentId]) : nil
        location = Location.create!(id: params[:locationId], name: params[:name], remark: params[:remark],
                                    status: params[:status], parent: parent)
        {result: 1, content: location}
      end
    end
  end
end