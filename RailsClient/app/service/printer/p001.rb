module Printer
  class P001<Base
    Head=[:id, :whouse, :delivery_date, :user]
    Body=[:package_id, :part_id, :quantity, :w_date, :receive_position]

    def initialize(id=nil)
      self.data_set =[]
      self.id=id
    end

    def generate_data
      f=Forklift.find(self.id)
      head={id: f.id, whouse: f.whouse_id, delivery_date: f.created_at, user: f.user_id}
      heads=[]
      Head.each do |k|
        heads<<{Key: k, Value: head[k]}
      end
      packages=f.packages
      packages.each do |p|
        body={package_id: p.id, part_id: p.part_id, quantity: p.quantity, w_date: p.in_date, receive_position: 'POSITION'}
        bodies=[]
        Body.each do |k|
          bodies<<{Key: k, Value: body[k]}
        end
        self.data_set <<(heads+bodies)
      end
    end
  end
end