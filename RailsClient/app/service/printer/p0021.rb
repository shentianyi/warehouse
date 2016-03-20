# print delivery, jx to sh leoni
module Printer
  class P0021<Base
    HEAD=[:delivery_nr, :delivery_date, :from_addr, :to_addr, :totalnr_forklift, :totalnr_mupan, :num_paperbox, :totalnr_nps]
    BODY=[:forklift_nr, :batch_nr, :part_nr, :czleoni_partnr, :total_qty, :unit, :num_bucket, :remark]


    def generate_data
      d=LogisticsContainer.find(self.id)
      dp=DeliveryPresenter.new(d)

      head={
          delivery_nr: d.container_id,
          delivery_date: dp.delivery_date.to_s,
          from_addr: d.source_location.nil? ? '' : d.source_location.name.to_s,
          to_addr: d.des_location.nil? ? '' : d.des_location.name.to_s,
          totalnr_forklift: LogisticsContainerService.count_all_forklifts(d).to_s,
          totalnr_mupan: LogisticsContainerService.count_all_forklifts(d).to_s,
          num_paperbox: LogisticsContainerService.count_all_packages(d).to_s,
          totalnr_nps: LogisticsContainerService.count_all_packages(d).to_s
      }
      heads=[]
      HEAD.each do |k|
        heads<<{Key: k, Value: head[k]}
      end
      forklifts=LogisticsContainerService.get_forklifts(d)

      forklifts.each do |f|

        packages=LogisticsContainerService.get_packages(f)
        packages.each do |ps|
          part=Part.find_by_id(ps.package.part_id)
          bodies=[]
          body={
              forklift_nr: f.container_id.to_s,
              batch_nr: ps.package.extra_batch.to_s,
              part_nr: ps.package.extra_sh_part_id.to_s,
              czleoni_partnr: ps.package.extra_cz_part_id.to_s,
              total_qty: ps.package.quantity.to_s,
              unit: ps.package.extra_unit.to_s,
              num_bucket: 1,
              remark: ps.package.remark.to_s
          }
          p '----------------------------------------'
          p body
          p '----------------------------------------'
          BODY.each do |k|
            bodies<<{Key: k, Value: body[k]}
          end

          self.data_set <<(heads+bodies)

        end
      end


    end
  end
end
