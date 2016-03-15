# print delivery
module Printer
  class P002<Base
    HEAD=[:id, :total_nr, :numOfMP, :nps, :send_addr, :receive_addr, :delivery_date]
    BODY=[:forklift_id, :HU_Nr, :eighthundred_nr, :quantity, :Part_nr, :less_nr, :batch_nr]


    def generate_data
      d=LogisticsContainer.find(self.id)
      dp=DeliveryPresenter.new(d)

      head={id: d.container_id,
            total_nr: LogisticsContainerService.count_all_forklifts(d).to_s,
            numOfMP: LogisticsContainerService.count_all_forklifts(d).to_s,
            nps: LogisticsContainerService.count_all_packages(d).to_s,
            send_addr: d.source_location.nil? ? '' : d.source_location.address.to_s,
            receive_addr: d.des_location.nil? ? '' : d.des_location.address.to_s,
            delivery_date: dp.delivery_date.to_s}
      heads=[]
      HEAD.each do |k|
        heads<<{Key: k, Value: head[k]}
      end
      forklifts=LogisticsContainerService.get_forklifts(d)

      forklifts.each do |f|

        packages=LogisticsContainerService.get_packages(f)
        packages.each do |ps|
          bodies=[]
          body={forklift_id: f.container_id.to_s,
                HU_Nr: ps.package.id.to_s,
                eighthundred_nr: ps.package.extra_800_no.to_s,
                quantity: ps.package.quantity.to_s,
                Part_nr: ps.package.part_id.to_s,
                less_nr: ps.package.extra_sh_part_id.to_s,
                batch_nr: ps.package.extra_batch.to_s}
          BODY.each do |k|
            bodies<<{Key: k, Value: body[k]}
          end

          self.data_set <<(heads+bodies)

        end
      end


    end
  end
end
