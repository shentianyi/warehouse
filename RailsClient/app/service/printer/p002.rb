# print delivery
module Printer
  class P002<Base
    HEAD=[:id, :send_addr, :receive_addr, :delivery_date,:total_packages]
    BODY=[:forklift_id, :quantity, :whouse]


    def generate_data
      d=LogisticsContainer.find(self.id)

      head={id: d.id,
            total_packages: d.packages.count,
            send_addr: d.source.nil? ? '' : d.source.address,
            receive_addr: d.destination.nil? ? '' : d.destination.address,
            delivery_date: d.delivery_date.nil? ? '' : d.delivery_date.localtime.strftime('%Y.%m.%d %H:%M')}
      heads=[]
      HEAD.each do |k|
        heads<<{Key: k, Value: head[k]}
      end
      forklifts=d.forklifts
      forklifts.each do |f|
        body={forklift_id: f.id, quantity: f.sum_packages, whouse: f.whouse_id}
        bodies=[]
        BODY.each do |k|
          bodies<<{Key: k, Value: body[k]}
        end
        self.data_set <<(heads+bodies)
      end
    end
  end
end
