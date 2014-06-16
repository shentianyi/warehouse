module Printer
  class P003<Base
    HEAD=[:id,:receive_addr,:user, :receive_date]
    BODY=[:forklift_id,:quantity,:receive_qty,:status,:whouse]

    def initialize(id=nil)
      self.data_set =[]
      self.id=id
    end

    def generate_data
      d=Delivery.find(self.id)
      head={id: d.id, receive_addr:d.destination.address,user:d.receiver_id,receive_date:d.received_date}
      heads=[]
      HEAD.each do |k|
        heads<<{Key: k, Value: head[k]}
      end
      forklifts=d.forklifts
      forklifts.each do |f|
        body={forklift_id:f.id,quantity:f.sum_packages,receive_qty:f.accepted_packages,status:f.state,whouse:f.whouse_id}
        bodies=[]
        BODY.each do |k|
          bodies<<{Key: k, Value: body[k]}
        end
        self.data_set <<(heads+bodies)
      end
    end
  end
end