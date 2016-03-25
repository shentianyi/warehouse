# print pick list
module Printer
  class P006<Base
    HEAD=[:pl_nr, :create_date]
    BODY=[:leoni_nr, :jx_nr, :ask_qty, :position, :kucun, :remark]

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
      pick_items=p.pick_items.select("SUM(pick_items.quantity) as total, pick_items.*").group("part_id").order(state: :asc, is_emergency: :desc)

      # if pick_items.count == 0
      #   pick_items = p.pick_items.order(state: :asc, is_emergency: :desc)
      # end

      pick_items.each do |i|

        jx_part=Part.find_by_id(i.part_id)
        if jx_part
          sh_part= jx_part.part_clients.where(client_tenant_id: Tenant.find_by_code('CZL').id).first
        end
        body= {
            leoni_nr: sh_part.blank? ? '' : sh_part.client_part_nr,
            jx_nr: jx_part.blank? ? '' : jx_part.nr,
            ask_qty: i.quantity,
            position: NStorageService.get_positions(i.part_id,p.user.location),
            kucun: NStorageService.get_total_stock_count(i.part_id,p.user.location),
            remark: i.remark||' '
        }

        bodies=[]
        BODY.each do |k|
          bodies<<{Key: k, Value: body[k]}
        end
        i.update(state: PickItemState::PRINTED)
        self.data_set <<(heads+bodies)
      end
    end
  end
end