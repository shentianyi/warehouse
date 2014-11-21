# print received packages detail
module Printer
  class P005<Base
    HEAD=[:id, :receive_addr, :user, :receive_date]
    BODY=[:forklift_id, :package_id, :whouse]


    def generate_data
      d=LogisticsContainer.find(self.id)
      dp=DeliveryPresenter.new(d)

      head={id: d.container_id,
            receive_addr: d.des_location.nil? ? '' : d.des_location.address,
            user: dp.received_user,
            receive_date: dp.received_date}


      heads=[]
      HEAD.each do |k|
        heads<<{Key: k, Value: head[k]}
      end
      packages=LogisticsContainerService.get_accepted_packages(d)

      packages.each do |p|
        f=p.parent
        body={forklift_id: f.container_id, package_id: p.container_id, whouse: f.destinationable.nil? ? '' : f.destinationable.name}
        bodies=[]
        BODY.each do |k|
          bodies<<{Key: k, Value: body[k]}
        end
        self.data_set <<(heads+bodies)
      end
    end
  end
end
