class NStorageService


  def self.get_positions part_id, location
    positions=[]

    ids= NStorage.where(partNr: part_id,
                        ware_house_id: location.whouse_ids).order(fifo: :asc).pluck(:position_id).uniq
    ids.each do |id|
      if p=Position.find_by_id(id)
        positions<<p.nr
      end
    end
    positions.join(';')
  end

  def self.get_total_stock_count part_id, location
    # if storage=NStorage.select("SUM(n_storages.qty) as total").where(partNr: part_id).first
    #   storage.total
    # else
    #   0
    # end

    NStorage.where(partNr: part_id,
                   ware_house_id: location.whouse_ids).count
  end

  def self.get_remark part, location, qty
    if part
      count=NStorage.where(partNr: part.id, ware_house_id: location.whouse_ids).count
      if count==0
        "零库存"
      elsif count<qty
        "库存不足"
      else
        ""
      end
    else
      "仓库无此型号"
    end
  end

  def self.get_mrp_part_stock_by_nrs part_nrs
    get_part_stock_by_nrs(part_nrs, Whouse.mrp_whouses)
  end

  def self.get_part_stock_by_nrs part_nrs, whouses=nil
    q= NStorage.where(partNr: part_nrs)
    if whouses.present?
      q=q.where(ware_house_id: whouses.pluck(:id))
    end
    q.joins('inner join parts on n_storages.partNr=parts.id').group(:partNr)
        .select('sum(n_storages.qty) as qty,n_storages.fifo,n_storages.partNr,parts.unit')
  end

  def self.move_stock data
    js_data=JSON.parse(data)
    msg=move_stock_check js_data
    p js_data

    if msg.result
      NStorage.transaction do
        js_data.each do |d|
          part=Part.find_by_nr(d['part_id'])
          storage=NStorage.find_by_packageId(d['package_id'])
          toWh=Whouse.find_by_nr(KskResultState.decode_destination(d['result_code'].to_i))
          if enter_code.include?(d['result_code'].to_i)
            WhouseService.new.enter_stock({
                                              partNr: part.id,
                                              qty: 1,
                                              fifo: Time.now(),
                                              toWh: toWh.id,
                                              toPosition: toWh.default_position.id,
                                              packageId: d['package_id']
                                          })
          elsif move_code.include?(d['result_code'].to_i)
            fromWh=Whouse.find_by_nr(KskResultState.decode_source(d['result_code'].to_i))
            WhouseService.new.move({
                                       toWh: toWh.id,
                                       toPosition: toWh.default_position.id,
                                       fromWh: fromWh.id,
                                       fromPosition: fromWh.default_position.id,
                                       partNr: part.id,
                                       qty: d['qty']
                                       # fifo: storage.fifo,
                                       # packageId: d[:package_id]
                                   })
          else

          end
        end
      end
    else
      return {result_code: 0, messages: msg.content}
    end

    {
        result_code: 1,
        messages: "Success"
    }
  end

  def self.move_stock_check data
    msg=Message.new(contents: [])

    data.each do |d|
      unless part=Part.find_by_nr(d['part_id'])
        msg.contents << "零件号不存在"
      end
      if enter_code.include?(d['result_code'].to_i)
        puts '99999999999999999999999999999999999999999999999999'
        if d['package_id'].blank?
          msg.contents << "唯一码不能为空"
        else
          if NStorage.exists_package?(d['package_id'])
            msg.contents << "唯一码已存在"
          end
        end
      elsif move_code.include?(d['result_code'].to_i)
        puts '99999999999999999999999999999999999999999999999999'
        unless d['package_id'].blank?
          msg.contents << "唯一码#{d['package_id']}不应该存在"
        end
        if d['qty'].to_i <= 0
          msg.contents << "数量：#{d['qty']}不合法"
        end
        # if part
        #   unless NStorage.where(packageId: d[:package_id], partNr: part.id).first
        #     msg.contents << "唯一码和零件号的对应关系不正确"
        #   end
        # end
      else
        msg.contents << "result code 不正确"
      end
      puts '99999999999999999999999999999999999999999999999999'
    end

    unless msg.result=(msg.contents.size==0)
      msg.content=msg.contents.join('/')
    end
    msg
  end

  def self.enter_code
    [KskResultState::SEMIFINISHED_ADD, KskResultState::FINISHED_ADD]
  end

  def self.move_code
    [KskResultState::MATERIAL_MOVE_FROM_RECEIVE, KskResultState::SEMIFINISHED_MOVE_FROM_RECEIVE, KskResultState::SEMIFINISHED_MOVE_FROM_MATERIAL,
     KskResultState::FINISHED_MOVE_FROM_MATERIAL, KskResultState::FINISHED_MOVE_FROM_SEMI, KskResultState::SCRAP_ADD_FROM_MATERIAL, KskResultState::SCRAP_ADD_FROM_SEMI,
     KskResultState::SCRAP_ADD_FINISHED, KskResultState::REWORK_ADD_FROM_RECEIVE, KskResultState::REWORK_ADD_FROM_MATERIAL, KskResultState::REWORK_ADD_FROM_SEMI,
     KskResultState::REWORK_ADD_FROM_FINISHED]
  end


end