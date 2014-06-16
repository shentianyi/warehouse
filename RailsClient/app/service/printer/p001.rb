module Printer
  class P001<Base
    HEAD=[:id, :whouse, :delivery_date, :user]
    BODY=[:package_id, :part_id, :quantity, :w_date, :receive_position]


    def generate_data
      f=Forklift.find(self.id)
      head={id: f.id, whouse: f.whouse_id, delivery_date: f.created_at, user: f.user_id}
      heads=[]
      HEAD.each do |k|
        heads<<{Key: k, Value: head[k]}
      end
      packages=f.packages
      packages.each do |p|
        body={package_id: p.id, part_id: p.part_id, quantity: p.sum_packages, w_date: p.in_date, receive_position: p.position.detail}
        bodies=[]
        BODY.each do |k|
          bodies<<{Key: k, Value: body[k]}
        end
        self.data_set <<(heads+bodies)
      end
    end
  end
end