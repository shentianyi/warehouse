module Printer
  class P004<Base
    HEAD=[:id, :receive_addr, :user, :receive_date]
    BODY=[:forklift_id, :package_id, :whouse]


    def generate_data
      d=Delivery.find(self.id)
      head={id: d.id, receive_addr: d.destination.address, user: d.receiver_id, receive_date: d.received_date}
      heads=[]
      HEAD.each do |k|
        heads<<{Key: k, Value: head[k]}
      end
      packages=d.rejected_packages
      packages.each do |p|
        body={forklift_id: p.forklift_id, package_id: p.id, whouse: p.whouse_id}
        bodies=[]
        BODY.each do |k|
          bodies<<{Key: k, Value: body[k]}
        end
        self.data_set <<(heads+bodies)
      end
    end
  end
end