# print movement list
module Printer
  class P009<Base
    HEAD=[:transfernote_Nr, :transfer_quantity, :date]
    BODY=[:Nr, :part_Nr, :unique_code, :quantity, :originalW, :target_W, :remark]

    def generate_data
      m = MovementList.find_by_id(self.id)
      head={id: m.id, count: m.movements.count, created_at: m.created_at.localtime.strftime('%Y.%m.%d %H:%M:%S')}
      heads=[]
      HEAD.each do |k|
        heads<<{Key: k, Value: head[k]}
      end

      movements = m.movements

      movements.each do |i|
        body= {
            Nr: i.id,
            part_Nr: i.partNr,
            unique_code: i.packageId,
            quantity:i.qty,
            originalW: i.from_id,
            target_W: i.to_id,
            remark: i.remark||' '
        }

        bodies=[]
        BODY.each do |k|
          bodies<<{Key: k, Value: body[k]}
        end
        self.data_set <<(heads+bodies)
      end
    end
  end
end