# print delivery, jx to sh leoni
module Printer
  class P0021<Base
    HEAD=[:delivery_nr, :delivery_date, :from_addr, :to_addr, :totalnr_forklift, :totalnr_mupan, :num_paperbox, :totalnr_nps]
    BODY=[:forklift_nr, :batch_nr, :part_nr, :czleoni_partnr, :total_qty, :unit, :num_bucket, :remark]


    def generate_data
      d=LogisticsContainer.find(self.id)
      dp=DeliveryPresenter.new(d)
      count={
          wooden: 0,
          box: 0,
          nps: 0
      }
      PackageType.all.each do |t|
        count[t.nr.to_sym] =LogisticsContainerService.get_packages(d).joins(package: :part).where(parts: {package_type_id: t.id}).count
      end
      head={
          delivery_nr: d.container_id,
          delivery_date: dp.delivery_date.to_s,
          from_addr: d.source_location.nil? ? '' : d.source_location.name.to_s,
          to_addr: d.des_location.nil? ? '' : d.des_location.name.to_s,
          totalnr_forklift: LogisticsContainerService.count_all_forklifts(d).to_s,
          totalnr_mupan: count[:wooden], #d.delivery.extra_wooden_count.to_s,
          num_paperbox: count[:box], #d.delivery.extra_box_count.to_s,
          totalnr_nps: count[:nps] #d.delivery.extra_nps_count.to_s
      }
      heads=[]
      HEAD.each do |k|
        heads<<{Key: k, Value: head[k]}
      end

      forklifts=LogisticsContainerService.get_forklifts(d)

      parts=[]
      forklifts.each do |f|

        packages=LogisticsContainerService.get_packages(f)
        packages.each do |ps|
          part=Part.find_by_id(ps.package.part_id)
          parts<<part.id
          bodies=[]
          body={
              forklift_nr: f.container_id.to_s,
              batch_nr: ps.package.extra_batch.to_s,
              part_nr: part.sh_part_nr, #ps.package.part.present? ?  ps.package.part.nr : '',
              czleoni_partnr: part.cz_part_nr, #ps.package.extra_cz_part_id.to_s,
              total_qty: ps.package.quantity.to_s,
              unit: part.unit, #ps.package.extra_unit.to_s,
              num_bucket: 1,
              remark: ps.package.remark.to_s
          }

          BODY.each do |k|
            bodies<<{Key: k, Value: body[k]}
          end

          self.data_set <<(heads+bodies)

        end
      end


      parts=parts.uniq

      if d.order
        d.order.order_items.pluck(:part_id).uniq.each do |part_id|
          unless parts.include?(part_id)
            if part=Part.find_by_id(part_id)
              bodies=[]
              remark=''
              if d.source_location.default_whouse
                if storage=NStorage.where(ware_house_id: d.source_location.default_whouse.id, partNr: part_id).first
                  remark='未择货'
                else
                  remark='无库存'
                end
              end
              body={
                  forklift_nr: '',
                  batch_nr: '',
                  part_nr: part.sh_part_nr,
                  czleoni_partnr: part.cz_part_nr,
                  total_qty: '',
                  unit: '',
                  num_bucket: 1,
                  remark: remark
              }
              BODY.each do |k|
                bodies<<{Key: k, Value: body[k]}
              end
              self.data_set <<(heads+bodies)
            end
          end
        end
      end


    end
  end
end
