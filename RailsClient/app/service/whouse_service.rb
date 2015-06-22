class WhouseService
  def validate_fifo_time(fifo)
    puts "---------------88888888888#{fifo}"
    t = fifo.to_time
    raise 'fifo time is invalid' if t > Time.now
    t
  end

  def validate_position_pattern(positionPattern)
    # convert position to Regex object, if no exception raised, it's valid
    /"#{positionPattern}/
  end

  def validate_position(wh, position)
    regex = wh.positionPattern ? /"#{wh.positionPattern}/ : nil
    raise 'position pattern is invalid' if not position.present? or regex and regex.match(position).nil?
  end

  def get_fifo_time_range(fifo)
    [fifo[:start].to_time, fifo[:end].to_time]
  end

  def create_whouse(params)
    puts '----------------'
    if location = Location.find_by(id: params[:locationId])
      validate_position_pattern(params[:positionPattern])
      wh = Whouse.create!(id: params[:id], name: params[:name], position_pattern: params[:positionPattern],
                          location_id: location.id)
    else
      raise 'locationId does not exists'
    end
  end

  def enter_stock(params)
    # validate fifo
    puts '----------------------ss'
    fifo = validate_fifo_time(params[:fifo])
    # validate whId existing
    wh = Whouse.find_by(id: params[:toWh])
    raise '仓库未找到' unless wh
    # validate uniqueId
    raise 'uniqueId already exists!' if params[:uniqueId].present? and NStorage.find_by(params[:uniqueId])
    s = nil
    if params[:packageId] and s = NStorage.find_by(packageId: params[:packageId], partNr: params[:partNr],
                                                   fifo: fifo)
      unless params[:uniq].present?
        s.qty = s.qty + params[:qty]
        s.save!
      else
       # raise params[:packageId]

        #raise 'Already Enter Stock' unless params[:wms].present?
      end
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
  end


  def move(params)
    # XXX does not work now
    type = MoveType.find_by!(typeId: 'MOVE')
    toWh = Whouse.find_by(id: params[:toWh])
    raise '仓库未找到' unless toWh
    # validate_position(toWh, params[:toPosition])
    data = {to_id: toWh.id, toPosition: params[:toPosition], type_id: type.id}
    if params[:uniqueId].present?
      #Move(uniqueId,toWh,toPosition,type)
      # find from wh
      storage = NStorage.find_by(uniqueId: params[:uniqueId])
      raise '包装未入库！' unless storage.blank?
      # update parameters of movement creation
      data.update({from_id: storage.ware_house_id, fromPosition: storage.position,
                   uniqueId: params[:uniqueId], qty: storage.qty, fifo: storage.fifo, partRr: storage.partNr})
      # create movement
      Movement.create!(data)

      # update storage
      storage.update!(ware_house_id: toWh.id, position: params[:toPosition])
    elsif params[:packageId].present?
      # Move(packageId,partnr, quantity,toWh, toPosition,type)
      # find from wh
      storage = nil
      if params[:partNr].blank?
        storage = NStorage.find_by(packageId: params[:packageId])
        params[:partNr]=storage.partNr if storage
      else
        storage = NStorage.find_by(packageId: params[:packageId], partNr: params[:partNr])
      end

      puts "############{storage.to_json}"
      raise '包装未入库！' if storage.nil?

      #if storage
      #  pre=NStorage.where(partNr: storage.partNr,ware_house_id:storage.ware_house_id).where('fifo<?', storage.fifo).first
      #  raise "FIFO!不能移库,此箱入库时间为:#{storage.fifo.localtime.strftime('%Y-%m-%d')}" if pre
      #end
      #storage = NStorage.find_by!(packageId: params[:packageId], partNr: params[:partNr])
      # validate package qty
      raise '移库量大于剩余量' if params[:qty] > storage.qty

      # update parameters of movement creation
      data.update({from_id: storage.ware_house_id, fromPosition: storage.position,
                   packageId: params[:packageId], qty: params[:qty], fifo: storage.fifo, partNr: storage.partNr})
      # create movement
      Movement.create!(data)
      # adjust storage
      ## adjust to storage
      tostorage = NStorage.find_by(ware_house_id: toWh.id, partNr: params[:partNr], position: params[:toPosition],packageId:nil)
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
    elsif [:partNr, :qty, :fromWh, :fromPosition].reduce(true) { |seed, i| seed and params.include? i }
      # Move(partNr, qty, fromWh,fromPosition,toWh,toPosition,type)
      # Move(partNr, qty, fifo,fromWh,fromPosition,toWh,toPosition,type)
      fromWh = Whouse.find_by(id: params[:fromWh])
      raise '目标仓库未找到' unless fromWh
      #validate_position(fromWh, params[:fromPosition])
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
      raise '库存不足' if sumqty = storages.reduce(0) { |seed, s| seed + s.qty } < params[:qty]
      storages.reduce(params[:qty]) do |restqty, storage|
        break if restqty <= 0
        # update parameters of movement creation
        data.update({from_id: storage.ware_house_id, fromPosition: storage.position,
                     fifo: storage.fifo, partNr: storage.partNr})
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

    {result: 1, content: 'move success'}
  end

end
