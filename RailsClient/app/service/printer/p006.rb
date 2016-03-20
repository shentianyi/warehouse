# print pick list
module Printer
  class P006<Base
    HEAD=[:pl_nr, :created_date]
    BODY=[:leoni_nr, :czleoni_nr, :ask_qty, :position, :kucun, :send_nr, :remark]

    def generate_data
      p=PickList.find_by_id(self.id)
      head={
          pl_nr: p.id,
          created_date: p.created_at.localtime.strftime('%Y.%m.%d %H:%M:%S')
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

        body= {
            leoni_nr: i.part_id,
            czleoni_nr: i.part_id,
            ask_qty: i.quantity,
            position: NStorageService.get_positions(i.part_id),
            kucun: NStorageService.get_total_stock(i.part_id),
            remark: i.remark||' '
        }

        bodies=[]
        BODY.each do |k|
          bodies<<{Key: k, Value: body[k]}
        end
        self.data_set <<(heads+bodies)
        i.update(state: PickItemState::PRINTED)
      end
    end
  end
end