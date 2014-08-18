#print fors report
module Printer
  class P007<Base
    HEAD=[:id,:user,:created_at,:total_packages,:whouse]
    BODY=[:package_id,:part_id,:from_whouse_code,:from_whouse_position,:to_whouse_code,:to_whouse_position,:quantity,:transfer_data]

    def generate_data
      f = Forklift.find_by_id(self.id)
      head = {
          id:f.id,
          total_packages: f.sum_packages,
          created_at: f.created_at.nil? ? '' : f.created_at.localtime.strftime('%Y.%m.%d %H:%M'),
          whouse: f.whouse.name,
          user: f.stocker_id
      }

      heads=[]
      HEAD.each do |k|
        heads<<{Key: k, Value: head[k]}
      end

      packages = f.packages
      packages.each do |p|
        body = {
            package_id: p.id,
            part_id: p.part_id,
            quantity: p.quantity_str,
            from_whouse_code: SysConfigCache.trans_warehouse_value,
            from_whouse_position: Position.trans_position,
            to_whouse_code: p.forklift.whouse.name,
            to_whouse_position: p.position.detail,
            transfer_data: '\n\n\n#{p.forklift.whouse.name}\n#{p.position.detail}\n#{p.quantity_str}\n#{p.part_id}'
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