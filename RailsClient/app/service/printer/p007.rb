#print fors report
module Printer
  class P007<Base
    HEAD=[:id,:user,:delivery_date,:whouse,:total_packages,:from_whouse_code,:from_whouse_position]
    BODY=[:part_id,:to_whouse_code,:to_whouse_position,:quantity,:transfer_data]

    def generate_data
      f = Forklift.find_by_id(self.id)
      whosue = f.whouse.nil? ? '' : f.whouse.name
      stocker = f.stocker.nil? ? '': f.stocker.name
      head = {
          id:f.id,
          delivery_date: f.created_at.nil? ? '' : f.created_at.localtime.strftime('%Y.%m.%d %H:%M'),
          whouse: whosue,
          user: stocker,
          total_packages: f.sum_packages,
          from_whouse_code: SysConfigCache.trans_warehouse_value,
          from_whouse_position: Position.trans_position
      }

      heads=[]
      HEAD.each do |k|
        heads<<{Key: k, Value: head[k]}
      end

      packages = f.packages

      packages.each do |p|
        position = p.position.nil? ? '' : p.position.detail

        body = {
            part_id: p.part_id,
            quantity: p.quantity_str,
            to_whouse_code: whosue,
            to_whouse_position:  position,
            transfer_data: "\r\r\r#{whosue}\r#{position}\r#{p.quantity_str}\r#{p.part_id}"
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