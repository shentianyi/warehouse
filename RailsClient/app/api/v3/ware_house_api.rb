#encoding: utf-8
module V3
  class WareHouseApi < Grape::API

    format :json
    rescue_from :all do |e|
      {result: 0, content: "Error: #{e.class.name} : [#{e.message}]"}
    end

    helpers do
      def validate_fifo_time(fifo)
        t = fifo.to_time
        raise 'fifo time is invalid' if t > Time.now
        t
      end
    end

    namespace :whouse do

      desc 'Get WareHouse list.'
      get do
        # guard!
        whs = WareHouse.all
        {result: 1, content: {ware_houses: whs}}
      end

      desc 'Create WareHouse.'
      params do
        requires :id, type: Integer, desc: 'require whId'
        requires :name, type: String, desc: 'require WareHouse name'
        requires :locationId, type: String, desc: 'require locationId'
        requires :positionPattern, type: String, desc: 'require positionPattern'
      end
      post do
        # validate locationId
        if location = NLocation.find_by(locationId: params[:locationId])
          validate_position_pattern( params[:positionPattern] )
          wh = WareHouse.create!(whId: params[:id], name: params[:name], positionPattern: params[:positionPattern])
        else
          raise 'locationId does not exists'
        end
      end

      desc 'Enter Stock.'
      params do
        requires :partNr, type: String, desc: 'require partNr'
        requires :qty, type: Integer, desc: 'require qty(quantity)'
        requires :fifo, type: String, desc: 'require fifo'
        requires :toWh, type: String, desc: 'require toWh(to warehouse, whId)'
        requires :toPosition, type: String, desc: 'require toPosition'
        optional :uniqueId, type: String, desc: 'require uniqueId'
        optional :packageId, type: String, desc: 'require packageId'
      end
      post :enter_stock do
        # validate fifo
        fifo = validate_fifo_time(params[:fifo])
        # validate whId existing
        wh = WareHouse.find_by!(whId: params[:toWh])
        # validate uniqueId
        raise 'uniqueId already exists!' if params[:uniqueId].present? and NStorage.find_by(params[:uniqueId])
        s = nil
        if params[:packageId] and  s = NStorage.find_by(packageId: params[:packageId], partNr: params[:partNr],
                                                            fifo: fifo)
          s.qty = s.qty + params[:qty]
          s.save!
        else
          data = {partNr: params[:partNr], qty: params[:qty], fifo: fifo, ware_house: wh, position: params[:toPosition]}
          data[:uniqueId] = params[:uniqueId] if params[:uniqueId].present?
          data[:packageId] = params[:packageId] if params[:packageId].present?
          s = NStorage.create!(data)
        end
        {result: 1, content: s}
      end
    end

  end
end