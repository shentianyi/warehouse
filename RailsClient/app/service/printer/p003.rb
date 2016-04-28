# print accepted
module Printer
  class P003<Base
    HEAD=[:forklist_nr, :create_date]
    BODY=[:jx_batchnr, :shleoninr, :czleoninr, :qty, :unit, :num_buckle, :remark]

    def generate_data
      d=LogisticsContainer.find(self.id)
      dp=ForkliftPresenter.new(d)

      head={
          forklist_nr: d.container_id,
          create_date: dp.created_at.localtime.strftime('%Y.%m.%d %H:%M')
      }
      heads=[]
      HEAD.each do |k|
        heads<<{Key: k, Value: head[k]}
      end
      packages=LogisticsContainerService.get_packages(d)
      packages.each do |ps|
        body={
            jx_batchnr: ps.package.extra_batch.to_s,
            shleoninr: ps.package.extra_sh_part_id.to_s,
            czleoninr: ps.package.extra_cz_part_id.to_s,
            qty: ps.package.quantity.to_s,
            unit: ps.package.extra_unit.to_s,
            num_buckle: 1,
            remark: ps.package.remark.to_s
        }
        bodies=[]
        BODY.each do |k|
          bodies<<{Key: k, Value: body[k]}
        end
        self.data_set <<(heads+bodies)
      end


    end
  end
end
