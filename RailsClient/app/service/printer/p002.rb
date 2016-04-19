# print delivery
module Printer
  class P002<Base
    # HEAD=[:delivery_nr, :delivery_date, :from_addr, :to_addr, :totalnr_forklift, :totalnr_mupan, :num_paperbox, :totalnr_nps]
    # BODY=[:forklift_nr, :hu_nr, :eighthundred_nr, :part_nr, :lesspn, :total_qty, :batch_nr]


    def generate_data

      d=LogisticsContainer.find(self.id)

      # if d.des_location.nr=='JXJXLO'
        #接收
        self.code='P0020'
        self.data_set= Printer::P0020.new(self.id, 'P0020').data_set
      # elsif d.source_location.nr=='JXJXLO'
      #   #发货
      #   self.code='P0021'
      #   self.data_set= Printer::P0021.new(self.id, 'P0021').data_set
      # end

      # dp=DeliveryPresenter.new(d)
      #
      # head={
      #     delivery_nr: d.container_id,
      #     delivery_date: dp.delivery_date.to_s,
      #     from_addr: d.source_location.nil? ? '' : d.source_location.name.to_s,
      #     to_addr: d.des_location.nil? ? '' : d.des_location.name.to_s,
      #     totalnr_forklift: LogisticsContainerService.count_all_forklifts(d).to_s,
      #     totalnr_mupan: LogisticsContainerService.count_all_forklifts(d).to_s,
      #     num_paperbox: LogisticsContainerService.count_all_packages(d).to_s,
      #     totalnr_nps: LogisticsContainerService.count_all_packages(d).to_s
      # }
      # heads=[]
      # HEAD.each do |k|
      #   heads<<{Key: k, Value: head[k]}
      # end
      # forklifts=LogisticsContainerService.get_forklifts(d)
      #
      # forklifts.each do |f|
      #
      #   packages=LogisticsContainerService.get_packages(f)
      #   packages.each do |ps|
      #     part=Part.find_by_id(ps.package.part_id)
      #     bodies=[]
      #     body={
      #         forklift_nr: f.container_id.to_s,
      #         hu_nr: ps.package.id.to_s,
      #         eighthundred_nr: ps.package.extra_800_no.to_s,
      #         total_qty: ps.package.quantity.to_s,
      #         part_nr: part.blank? ? '' : part.nr.to_s,
      #         lesspn: ps.package.extra_sh_part_id.to_s,
      #         batch_nr: ps.package.extra_batch.to_s
      #     }
      #     p '----------------------------------------'
      #     p body
      #     p '----------------------------------------'
      #     BODY.each do |k|
      #       bodies<<{Key: k, Value: body[k]}
      #     end
      #
      #     self.data_set <<(heads+bodies)
      #
      #   end
    end


  end
end
