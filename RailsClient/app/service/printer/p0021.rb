# print delivery, jx to sh leoni
module Printer
  class P0021<Base
    HEAD=[:delivery_nr, :delivery_date, :from_addr, :to_addr, :totalnr_forklift, :totalnr_mupan, :num_paperbox, :totalnr_nps]
    BODY=[:forklift_nr, :batch_nr, :part_nr, :czleoni_partnr, :total_qty, :unit, :num_bucket, :remark,:nr]


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

      parts={}
      forklifts.each_with_index do |f,i|

        packages=LogisticsContainerService.get_packages(f)
        packages.each_with_index do |ps,ii|
          part=Part.find_by_id(ps.package.part_id)


          p '---------------'
          p part.id
          p parts
          p parts[part.id]
          p parts[part.id].blank?
          p '---------------'

          if parts[part.id].blank?
            parts[part.id]=1
          else
            parts[part.id]+=1
          end

          bodies=[]
          body={
              nr:ii+1,
              forklift_nr: "#{f.container_id}",
              batch_nr: d.batch_nr,#d.batch_no.nil? ? '' : d.batch_no,#ps.package.extra_batch.to_s,
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
      p '---------------'
      p parts
      p '---------------'

      if d.order
        d.order.order_items.select('*,sum(quantity) as quantity').group(:part_id).each do |item|
          part_id=item.part_id
          if part=Part.find_by_id(part_id)
            qty=item.quantity.to_i

            if parts[part_id].present?
              # if item.qty>parts[part_id]
              qty=item.quantity.to_i-parts[part_id]
              # else
              #   qty=0
              # end
            end

            if qty>0
              bodies=[]
              body={
                  forklift_nr: '',
                  batch_nr: '',
                  part_nr: part.sh_part_nr,
                  czleoni_partnr: part.cz_part_nr,
                  total_qty: '',
                  unit: '',
                  num_bucket: qty,
                  remark: item.remark
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


# unless parts.include?(part_id)
#   if part=Part.find_by_id(part_id)
#     bodies=[]
#     body={
#         forklift_nr: '',
#         batch_nr: '',
#         part_nr: part.sh_part_nr,
#         czleoni_partnr: part.cz_part_nr,
#         total_qty: '',
#         unit: '',
#         num_bucket: item.quantity.to_i,
#         remark: item.remark
#     }
#     BODY.each do |k|
#       bodies<<{Key: k, Value: body[k]}
#     end
#     self.data_set <<(heads+bodies)
#   end
# end