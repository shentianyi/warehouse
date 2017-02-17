# print movement list
module Printer
  class P010<Base
    HEAD=[:transfernote_Nr, :transfer_quantity, :date]
    BODY=[:Nr, :part_Nr, :unique_code, :quantity, :originalP, :target_W, :target_p]

    def generate_data
      m = MovementList.find_by_id(self.id)
      head={transfernote_Nr: m.id, transfer_quantity: m.movement_sources.count, date: m.created_at.localtime.strftime('%Y.%m.%d %H:%M:%S')}
      heads=[]
      HEAD.each do |k|
        heads<<{Key: k, Value: head[k]}
      end

      movement_sources = m.movement_sources

      movement_sources.each_with_index do |i, index|
        body= {
            Nr: index+1,
            part_Nr: i.partNr,
            unique_code: i.packageId,
            quantity:i.qty,
            originalP: i.fromPosition,
            target_W: i.toWh,
            target_P: i.toPosition
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
