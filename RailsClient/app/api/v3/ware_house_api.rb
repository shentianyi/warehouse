#encoding: utf-8
module V3
  class WareHouseApi < Grape::API
    namespace :whouse

    format :json
    rescue_from :all do |e|
      Rack::Response.new([e.message], 500).finish
    end

    helpers do
      def validate_fifo_time(fifo)
        t = fifo.to_time
        raise 'fifo time is invalid' if t > Time.now
        t
      end

      def validate_position_pattern(position)
        # convert position to Regex object, if no exception raised, it's valid
        /"#{wh.positionPattern}/
      end

      def validate_position(wh, position)
        regex = wh.positionPattern ? /"#{wh.positionPattern}/ : nil
        raise 'position pattern is invalid' if regex and regex.match(position).nil? or not position.present?
      end

      def get_fifo_time_range(fifo)
        [fifo[:start].to_time, fifo[:end].to_time]
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
      requires :id, type: String, desc: 'require whId'
      requires :name, type: String, desc: 'require WareHouse name'
      requires :locationId, type: String, desc: 'require locationId'
      requires :positionPattern, type: String, desc: 'require positionPattern'
    end
    post do
      # validate locationId
      if location = NLocation.find_by(locationId: params[:locationId])
        validate_position_pattern( params[:positionPattern] )
        wh = WareHouse.create!(whId: params[:id], name: params[:name], positionPattern: params[:positionPattern],
                               location_id: location.id)
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
      # requires :type, type: String, desc: 'require move type'
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
      data = {to_id: toWh.id, toPosition: params[:toPosition], type_id: type.id}
      if params[:uniqueId].present?
        #Move(uniqueId,toWh,toPosition,type)
        # find from wh
        storage = NStorage.find_by!(uniqueId: params[:uniqueId])
        # update parameters of movement creation
        data.update({ from_id: storage.ware_house_id, fromPosition: storage.position,
                      uniqueId: params[:uniqueId], qty: storage.qty, fifo: storage.fifo, partRr: storage.partNr})
        # create movement
        Movement.create!(data)

        # update storage
        storage.update!(ware_house_id: toWh.id, position: params[:toPosition])
      elsif params[:packageId].present?
        # Move(packageId,partnr, quantity,toWh, toPosition,type)
        # find from wh
        storage = NStorage.find_by!(packageId: params[:packageId], partNr: params[:partNr])
        # validate package qty
        raise 'No enough qty in package' if params[:qty] > storage.qty
        # update parameters of movement creation
        data.update({ from_id: storage.ware_house_id, fromPosition: storage.position,
                      packageId: params[:packageId], qty: params[:qty], fifo:storage.fifo, partNr: storage.partNr})
        # create movement
        Movement.create!(data)
        # adjust storage
        ## adjust to storage
        tostorage = NStorage.find_by(ware_house_id: toWh.id, partNr: params[:partNr], position: params[:toPosition])
        if tostorage.present?
          tostorage.update!(qty: tostorage.qty + params[:qty])
        else
          data = {partNr: params[:partNr], qty: params[:qty], fifo: storage.fifo, ware_house_id: toWh.id,
                  position: params[:toPosition], packageId: params[:packageId]}
          tostorage = NStorage.create!(data)
        end
        ## adjust src storage
        if params[:qty] == storage.qty
          storage.destroy!
        else
          storage.update!(qty: storage.qty - params[:qty])
        end
      elsif [:partNr, :qty, :fromWh, :fromPosition ].reduce(true){|seed, i| seed and params.include? i}
        # Move(partNr, qty, fromWh,fromPosition,toWh,toPosition,type)
        # Move(partNr, qty, fifo,fromWh,fromPosition,toWh,toPosition,type)
        fromWh = WareHouse.find_by!(whId: params[:fromWh])
        validate_position(fromWh, params[:fromPosition])
        # find storage records
        storages = NStorage.where(partNr: params[:partNr], ware_house_id: fromWh.id, position: params[:fromPosition])
        # add fifo condition if fifo param exists
        if params[:fifo]
          fifo = validate_fifo_time(params[:fifo])
          storage.where(fifo: fifo)
        end
        # order by fifo
        storage.order(fifo: :asc)
        # validate sum of storage qty is enough
        raise 'No enough qty in source' if sumqty = storages.reduce(0){|seed, s| seed + s.qty} < params[:qty]
        storages.reduce(params[:qty]) do |restqty, storage|
          break if restqty <= 0
          # update parameters of movement creation
          data.update({ from_id: storage.ware_house_id, fromPosition: storage.position,
                        fifo:storage.fifo, partNr: storage.partNr})
          if restqty >= storage
            # move all storage
            storage.update!(ware_house_id: toWh.id, position: params[:toPosition])
            data[:qty] = storage.qty
            restqty = restqty - storage.qty
          else
            # adjust source storage
            storage.update!(qty: storage.qty - restqty)
            # create target storage
            last = NStorage.create!(data)
            data[:qty] = restqty
            restqty = 0
          end
          # create movement
          Movement.create!(data)
          restqty
        end
      end

      {result:1, content: 'move success'}
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
        query = query.joins(:ware_house).where(WareHouse.arel_table[:whId].eq(params[:whId]))
      end
      # XXX no type relation in NStorage
      # if params[:movementType].present?
      #   query = query.joins(:type).where(MoveType.arel_table[:typeId].in(params[:movementType]))
      # end
      # query regex params
      regex_params = [:partNr, :packageId, :position, :uniqueId].select{|i| params.include? i}
      location = NLocation.arel_table
      query = regex_params.reduce(query) do |query, param|
        query.where(location[param].matches("%#{params[param]}%"))
      end
      if params[:fifo].present?
        start_time, end_time = get_fifo_time_range(params[:fifo])
        query = query.where(fifo: start_time..end_time)
      end
      {result:1, content: query}
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
      regex_params = [:partNr, :packageId, :uniqueId, :fromPosition, :toPosition].select{|i| params.include? i}
      location = NLocation.arel_table
      query = regex_params.reduce(query) do |query, param|
        query.where(location[param].matches("%#{params[param]}%"))
      end
      # format query with other params
      if params[:fifo].present?
        start_time, end_time = get_fifo_time_range(params[:fifo])
        query = query.where(fifo: start_time..end_time)
      end
      {result:1, content: query}
    end
  end
end