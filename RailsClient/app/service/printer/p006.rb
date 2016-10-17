# print pick list
module Printer
  class P006<Base
    HEAD=[:pl_nr, :create_date]
    BODY=[:czleoni_nr, :pro_desc, :qty, :uniq_id, :position, :remark]

    def generate_data
      p=PickList.find_by_id(self.id)
      head={
          pl_nr: p.id,
          create_date: p.created_at.localtime.strftime('%Y.%m.%d %H:%M:%S')
      }
      heads=[]
      HEAD.each do |k|
        heads<<{Key: k, Value: head[k]}
      end

      # pick_items=p.pick_items.where(state: PickItemState::PRINTING).order(state: :asc, is_emergency: :desc)
      # pick_items=p.pick_items.select("SUM(pick_items.quantity) as total, pick_items.*").group("part_id").order(state: :asc, is_emergency: :desc)
      pick_items=p.pick_items.order(state: :asc, is_emergency: :desc)

      # if pick_items.count == 0
      #   pick_items = p.pick_items.order(state: :asc, is_emergency: :desc)
      # end

      records=[]
      zero=[]
      pick_items.each do |i|

        jx_part=Part.find_by_id(i.part_id)

        unless jx_part
          zero.insert((i.is_supplement==true ? 0 : -1), {
              czleoni_nr: i.part_id,
              pro_desc: " ",
              qty: i.quantity.to_i,
              uniq_id: " ",
              position: " ",
              # is_supplement: (i.is_supplement==true ? '是' : '否'),
              remark: "仓库无此型号"
          })
          i.update(state: PickItemState::PRINTED)
          next
        end

        # if jx_part
        #   sh_part= jx_part.part_clients.where(client_tenant_id: Tenant.find_by_code('CZL').id).first
        # end

        pick_count=i.quantity
        location=Location.find_by_nr('SHJXLO')
        storages=NStorage.where(partNr: i.part_id, ware_house_id: (location.whouses.pluck(:id)-[location.send_whouse.id, location.receive_whouse.id]))
                     .order(ware_house_id: :desc).order(fifo: :asc)
        storages.each do |storage|
          if pick_count <= 0
            break
          end
          records.insert(sort_by_position(records, (storage.position.blank? ? ' ' : storage.position.nr), i.is_supplement),
                         {
                             czleoni_nr: jx_part.blank? ? i.part_id : jx_part.nr,
                             pro_desc: jx_part.blank? ? "" : jx_part.description,
                             qty: storage.qty,
                             uniq_id: storage.packageId,
                             position: storage.position.blank? ? ' ' : storage.position.nr,
                             # is_supplement: (i.is_supplement==true ? '是' : '否'),
                             remark: ' '
                         })
          pick_count-=storage.qty
        end

        if pick_count>0
          zero.insert((i.is_supplement==true ? 0 : -1), {
              czleoni_nr: jx_part.blank? ? i.part_id : jx_part.nr,
              pro_desc: jx_part.blank? ? "" : jx_part.description,
              qty: pick_count.to_i,
              uniq_id: " ",
              position: " ",
              # is_supplement: (i.is_supplement==true ? '是' : '否'),
              remark: "零库存"
          })
        end

        i.update(state: PickItemState::PRINTED)
      end

      # p records
      records +=zero
      records.each do |record|
        bodies=[]
        BODY.each do |k|
          bodies<<{Key: k, Value: record[k]}
        end
        self.data_set <<(heads+bodies)
      end
    end

    def sort_by_position array, position, is_supplement
      if array.blank?
        return 0
      else
        if !is_supplement && position.match(/^\w\s\d{2}/)
          array.each_with_index do |a, index|
            if a[:position].match(/^\w\s-\d{2}/)
              if a[:position].first > position.first
                return index
              elsif a[:position].first==position.first
                if a[:position].split(' ').last > position.split(' ').last
                  return index
                else
                  next
                end
              end
            else
              return index
            end
          end
        end
        return -1
      end
    end

    # def sort_by_position array, position, is_supplement
    #   if array.blank?
    #     return 0
    #   else
    #     if !is_supplement && position.match(/^\w\s\d{2}\s\d{2}/)
    #       array.each_with_index do |a, index|
    #         if a[:position].match(/^\w\s\d{2}\s\d{2}/)
    #           if a[:position].first > position.first
    #             return index
    #           elsif a[:position].first==position.first
    #             if a[:position].split(' ').last > position.split(' ').last
    #               return index
    #             else
    #               next
    #             end
    #           end
    #         else
    #           return index
    #         end
    #       end
    #     end
    #     return -1
    #   end
    # end

  end
end