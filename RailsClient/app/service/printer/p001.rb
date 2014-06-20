module Printer
  class P001<Base
    HEAD=[:id, :whouse, :delivery_date, :user]
    BODY=[:package_id, :part_id, :quantity, :w_date, :receive_position]


    def generate_data
      puts self.id
      f=Forklift.find_by_id(self.id)
      head={id: f.id, whouse: f.whouse.name, delivery_date: f.created_at.strftime('%Y.%m.%d')., user: f.stocker_id}
      heads=[]
      HEAD.each do |k|
        heads<<{Key: k, Value: head[k]}
      end
      packages=f.packages
      packages.each do |p|
        body={package_id: p.id, part_id: p.part_id, quantity: p.quantity_str, w_date: p.check_in_time, receive_position: p.get_position}
        puts body
        bodies=[]
        BODY.each do |k|
          bodies<<{Key: k, Value: body[k]}
        end
        self.data_set <<(heads+bodies)
      end
    end
  end
end