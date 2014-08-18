#print fors report
module Printer
  class P007<Base
    HEAD=[:id,:user,:created_at,:total_packages,:whouse]
    BODY=[:package_id,:part_id,:from_warehouse,:from_location,:to_warehouse,:to_location,:quantity]

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
            quantity: p.quantity,
            from_warehouse: SysConfigCache.trans_warehouse_value,
            from_location: Position.trans_position,
            to_warehouse: p.forklift.whouse.name,
            to_location: p.position.detail
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