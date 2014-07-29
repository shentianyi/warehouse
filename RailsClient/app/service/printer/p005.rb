# print rejected packages detail
module Printer
  class P005<Base
    HEAD=[:id, :receive_addr, :user, :receive_date]
    BODY=[:forklift_id, :package_id, :whouse]


    def generate_data
      d=Delivery.find(self.id)
      head={id: d.id,
            receive_addr:  d.destination.nil? ? '' : d.destination.address,
            user: d.receiver_id,
            receive_date: d.received_date.nil? ? '' : d.received_date.localtime.strftime('%Y.%m.%d')}
      heads=[]
      HEAD.each do |k|
        heads<<{Key: k, Value: head[k]}
      end
      packages=d.received_packages
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