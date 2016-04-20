# print delivery, to jx
module Printer
  class P0020<Base
    # HEAD=[:delivery_nr, :delivery_date, :from_addr, :to_addr, :totalnr_forklift, :totalnr_mupan, :num_paperbox, :totalnr_nps]
    HEAD=[
        :receivecompany_en, :receivecompany_cn, :receiveaddress_en, :receiveaddress_cn, :vendor_en, :vendor_cn, :vendoraddress_en, :vendoraddress_cn,
        :contact, :tel_nr, :gsdb_nr, :delivery_address, :packingslip_nr, :packingslip_date, :bill_nr, :convey_nr, :container_nr, :shipped_date, :eta_date, :tcf_dock

    ]
    # BODY=[:forklift_nr, :hu_nr, :eighthundred_nr, :part_nr, :lesspn, :total_qty, :batch_nr]
    BODY=[
        :last_delivery, :customer_service, :part_nr, :part_des, :qty, :unit, :gross_weight, :box_nr, :is_free, :manual_contactnr, :car_nr, :alert_nr
    ]


    def generate_data
      d=LogisticsContainer.find(self.id)
      dp=DeliveryPresenter.new(d)

      head={
          receivecompany_en: d.des_location.nil? ? '' : d.des_location.tenant.name.to_s,
          receivecompany_cn: d.des_location.nil? ? '' : d.des_location.tenant.name.to_s,
          receiveaddress_en: d.des_location.nil? ? '' : d.des_location.tenant.address.to_s,
          receiveaddress_cn: d.des_location.nil? ? '' : d.des_location.tenant.address.to_s,
          vendor_en: d.source_location.nil? ? '' : d.source_location.tenant.name.to_s,
          vendor_cn: d.source_location.nil? ? '' : d.source_location.tenant.name.to_s,
          vendoraddress_en: d.source_location.nil? ? '' : d.source_location.tenant.address.to_s,
          vendoraddress_cn: d.source_location.nil? ? '' : d.source_location.tenant.address.to_s,

          contact: ' ',
          tel_nr: ' ',
          gsdb_nr: ' ',
          delivery_address: d.des_location.nil? ? '' : d.des_location.name.to_s,
          packingslip_nr: d.delivery.extra_batch,
          packingslip_date: ' ',

          bill_nr: ' ',
          convey_nr: ' ',
          container_nr: ' ',
          shipped_date: dp.delivery_date.to_s,
          eta_date: ' ',
          tcf_dock: ' '
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
              last_delivery: ' ',
              customer_service: ' ',
              part_nr: part.blank? ? '' : part.nr.to_s,
              part_des: part.blank? ? '' : part.description.to_s,
              qty: ps.package.quantity.to_s,
              unit: part.blank? ? '' : part.unit.to_s,
              gross_weight: ' ',
              box_nr: ' ',
              is_free: ' ',
              manual_contactnr: ' ',
              car_nr: ' ',
              alert_nr: ' '
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
