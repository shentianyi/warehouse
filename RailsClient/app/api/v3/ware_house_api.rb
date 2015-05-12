#encoding: utf-8
module V3
  class WareHouseApi < Grape::API
    namespace :whouse

    format :json
    rescue_from :all do |e|
      error!({result: 0, content: "Error: #{e.class.name} : [#{e.message}]"}, 500)
    end

    helpers do
      def validate_fifo_time(fifo)
        t = fifo.to_time
        raise 'fifo time is invalid' if t > Time.now
        t
      end

      def validate_position_pattern(wh, position)
        TODO
      end

      def validate_position(wh, position)
        TODO
      end
    end

    desc 'Get WareHouse list.'
    get do
      # guard!
      whs = WareHouse.all
      {result: 1, content: whs}
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
      optional :uniqueId, type: String
      optional :packageId, type: String
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
        data = {partNr: params[:partNr], qty: params[:qty], fifo: fifo, ware_house_id: wh.id, position: params[:toPosition]}
        data[:uniqueId] = params[:uniqueId] if params[:uniqueId].present?
        data[:packageId] = params[:packageId] if params[:packageId].present?
        s = NStorage.create!(data)
      end
      type = MoveType.find_by!(typeId: 'ENTRY')
      data = {fifo: fifo, partNr: params[:partNr], qty: params[:qty], to_id: wh.id, toPosition: params[:toPosition],
              type_id: type.id}
      data[:uniqueId] = params[:uniqueId] if params[:uniqueId].present?
      data[:packageId] = params[:packageId] if params[:packageId].present?
      Movement.create!(data)
      {result: 1, content: s}
    end

    desc 'Stock Move.'
    params do
      # requires :fifo, type: String, desc: 'require fifo'
      requires :toWh, type: String, desc: 'require toWh(to warehouse, whId)'
      requires :toPosition, type: String, desc: 'require toPosition'
      requires :type, type: String, desc: 'require move type'
      optional :fromWh, type: String, desc: 'require toWh(to warehouse, whId)'
      optional  :fromPosition, type: String, desc: 'require toPosition'
      optional :qty, type: Integer, desc: 'require qty(quantity)'
      optional :partNr, type: String
      optional :uniqueId, type: String
      optional :packageId, type: String
      optional :fifo, type: String
    end
    post :move do
      # XXX does not work now

      type = MoveType.find_by!(typeId: 'MOVE')
      toWh = WareHouse.find_by!(whId: params[:toWh])
      validate_position(toWh, params[:toPosition])
      if params[:uniqueId].present?
        # find from wh
        storage = NStorage.find_by!(uniqueId: params[:uniqueId])
        # create movement
        data = {to_id: toWh.id, toPosition: params[:toPosition],
                type_id: type.id, from_id: storage.ware_house_id, fromPosition: storage.position,
                uniqueId: params[:uniqueId]}
        Movement.create!(data)
        # update storage
        storage.update!(ware_house_id: toWh.id, position: params[:toPosition])
      elsif params[:packageId].present?
        # find from wh
        storage = NStorage.find_by!(packageId: params[:packageId], partNr: params[:partNr])
        # validate package qty
        raise 'No enough qty in package' if params[:qty] > storage.qty
        # create movement
        data = {qty: params[:qty], type_id: type.id, packageId: params[:packageId],
                to_id: toWh.id, toPosition: params[:toPosition], partNr: params[:partNr],
                from_id: storage.ware_house_id, fromPosition: storage.position}
        Movement.create!(data)
      end

    end
  end
end