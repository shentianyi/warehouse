#encoding: utf-8
module V3
  class WareHouseApi < Grape::API


    format :json
    rescue_from :all do |e|
      Rack::Response.new([e.message], 500).finish
    end
    namespace :whouse do
      desc 'Get WareHouse list.'
      get do
        # guard!
        whs = Whouse.all
        {result: 1, content: whs}
      end

      desc 'Create WareHouse.'
      params do
        requires :id, type: String, desc: 'require whId'
        requires :name, type: String, desc: 'require WareHouse name'
        requires :locationId, type: String, desc: 'require locationId'
        requires :positionPattern, type: String, desc: 'require positionPattern'
      end
      post do
        WhouseService.new.create_whouse(params)
      end

      desc 'Enter Stock.'
      params do
        requires :partNr, type: String, desc: 'require partNr'
        requires :qty, type: Integer, desc: 'require qty(quantity)'
        requires :fifo, type: String, desc: 'require fifo'
        requires :toWh, type: String, desc: 'require toWh(to warehouse, whId)'
        requires :toPosition, type: String, desc: 'require toPosition'
        optional :uniqueId, type: String
        optional :packageId, type: String
      end
      post :enter_stock do
        WhouseService.new.enter_stock(params)
        {result: 1, content: s}
      end

      desc 'Stock Move.'
      params do
        # requires :fifo, type: String, desc: 'require fifo'
        requires :toWh, type: String, desc: 'require toWh(to warehouse, whId)'
        requires :toPosition, type: String, desc: 'require toPosition'
        # requires :type, type: String, desc: 'require move type'
        optional :fromWh, type: String, desc: 'require toWh(to warehouse, whId)'
        optional :fromPosition, type: String, desc: 'require toPosition'
        optional :qty, type: Integer, desc: 'require qty(quantity)'
        optional :partNr, type: String
        optional :uniqueId, type: String
        optional :packageId, type: String
        optional :fifo, type: String
      end
      post :move do
        WhouseService.new.move(params)
        {result: 1, content: 'move success'}
      end

      desc 'Query Stock.'
      params do
        # regex params
        optional :partNr, type: String
        optional :position, type: String
        optional :uniqueId, type: String
        optional :packageId, type: String
        # relations
        optional :whId, type: String
        # XXX no type relation in NStorage
        # optional :movementType, type: Array
        # other params
        optional :fifo, type: String
      end
      get :query_stock do
        query = NStorage
        # query relation params
        if params[:whId].present?
          query = query.joins(:ware_house).where(Whouse.arel_table[:whId].eq(params[:whId]))
        end
        # XXX no type relation in NStorage
        # if params[:movementType].present?
        #   query = query.joins(:type).where(MoveType.arel_table[:typeId].in(params[:movementType]))
        # end
        # query regex params
        regex_params = [:partNr, :packageId, :position, :uniqueId].select { |i| params.include? i }
        location = Location.arel_table
        query = regex_params.reduce(query) do |query, param|
          query.where(location[param].matches("%#{params[param]}%"))
        end
        if params[:fifo].present?
          start_time, end_time = get_fifo_time_range(params[:fifo])
          query = query.where(fifo: start_time..end_time)
        end
        {result: 1, content: query}
      end

      desc 'Query Movement.'
      params do
        # regex params
        optional :partNr, type: String
        optional :uniqueId, type: String
        optional :packageId, type: String
        optional :fromPosition, type: String
        optional :toPosition, type: String
        # relation params
        optional :movementType, type: Array
        optional :fromWh, type: String
        optional :toWh, type: String
        # other params
        optional :fifo, type: String
      end
      get :query_move do
        query = Movement
        # format query with relation params
        if params[:fromWh].present?
          from_arel = Arel::Table.new(:from)
          query = query.joins('inner join ware_houses `from` ON `from`.`id` = from_id').where(from_arel[:whId].eq(params[:fromWh]))
        end
        if params[:toWh].present?
          to_arel = Arel::Table.new(:to)
          query = query.joins('inner join ware_houses `to` ON `to`.`id` = from_id').where(to_arel[:whId].eq(params[:toWh]))
        end
        if params[:movementType].present?
          query = query.joins(:type).where(MoveType.arel_table[:typeId].in(params[:movementType]))
        end
        # format query with regex params
        regex_params = [:partNr, :packageId, :uniqueId, :fromPosition, :toPosition].select { |i| params.include? i }
        location = Location.arel_table
        query = regex_params.reduce(query) do |query, param|
          query.where(location[param].matches("%#{params[param]}%"))
        end
        # format query with other params
        if params[:fifo].present?
          start_time, end_time = get_fifo_time_range(params[:fifo])
          query = query.where(fifo: start_time..end_time)
        end
        {result: 1, content: query}
      end
    end
  end
end