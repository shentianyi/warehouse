#encoding: utf-8
module V3
  class LocationApi < Grape::API
    rescue_from :all do |e|
      {result: 0, content: "Error: #{e.class.name} : [#{e.message}]"}
    end

    helpers do
      def validate_position_pattern(pattern)
        # TODO:
      end
    end

    namespace :location do

      get do
        # guard!
        locations = NLocation.all
        {result: 1, content: locations}
      end

      params do
        requires :locationId, type: String, desc: 'require locationId'
        requires :name, type: String, desc: 'require Location name'
        requires :remark, type: String, desc: 'require remark of Location'
        # requires :parentId, type: String, desc: 'require parentId'
        requires :status, type: String, desc: 'require status'
      end
      post do
        # validate locationId
        parent = params[:parentId].present? ? NLocation.find_by!(parentId: params[:parentId]) : nil
        location = NLocation.create!(locationId: params[:locationId], name: params[:name], remark: params[:remark],
                                     status: params[:status], parent: parent)
        {result: 1, content: location}
      end
    end

  end
end