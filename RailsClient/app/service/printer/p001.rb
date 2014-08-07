# print package list
module Printer
  class P001<Base
    HEAD=[:id, :whouse, :delivery_date, :user,:total_packages]
    BODY=[:package_id, :part_id, :quantity, :w_date, :receive_position]


    def generate_data
      f=Forklift.find_by_id(self.id)

      head={id: f.id,
            total_packages:f.sum_packages,
            whouse: f.whouse.name,
            delivery_date: f.created_at.nil? ? '' : f.created_at.localtime.strftime('%Y.%m.%d %H:%M'),
            user: f.stocker_id}
      heads=[]
      HEAD.each do |k|
        heads<<{Key: k, Value: head[k]}
      end
      packages=f.packages
      packages.each do |p|
        body={package_id: p.id,
              part_id: PackageLabelRegex.part_prefix_string+ p.part_id,
              quantity: PackageLabelRegex.quantity_prefix_string+p.quantity_str,
              w_date: PackageLabelRegex.date_prefix_string+p.check_in_time,
              receive_position: p.get_position}
        bodies=[]
        BODY.each do |k|
          bodies<<{Key: k, Value: body[k]}
        end
        self.data_set <<(heads+bodies)
      end
    end
  end
end
