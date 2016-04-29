# print movement list
module Printer
  class P011<Base
    HEAD=[:list_date, :lister, :rcpt_nr, :client, :rtn_date]
    BODY=[:nr, :part_nr, :qty, :unit, :warehouse, :position, :rtn_rsn, :sample, :remark]

    def generate_data
      bp = BackPart.find_by_id(self.id)

      head={
          #list_date: Time.now.strftime('%Y.%m.%d %H:%M:%S'),
          list_date: bp.back_time.localtime.strftime('%Y.%m.%d %H:%M:%S'),
          lister: bp.user.blank? ? '' : bp.user.name,
          rcpt_nr: bp.id,
          client: bp.des_location.blank? ? '' : bp.des_location.name,
          rtn_date: bp.created_at.localtime.strftime('%Y.%m.%d %H:%M:%S')
      }
      heads=[]
      HEAD.each do |k|
        heads<<{Key: k, Value: head[k]}
      end

      bp_is = bp.back_part_items

      bp_is.each_with_index do |i, index|
        p i
        body= {
            nr: index+1,
            part_nr: i.part.blank? ? '' : i.part.nr,
            qty: i.qty,
            unit: 'EA',
            warehouse: i.whouse.blank? ? '' : i.whouse.nr,
            position: i.position.blank? ? '' : i.position.nr,
            rtn_rsn: i.back_reason,
            sample: i.has_sample ? "Y" : "N",
            remark: i.remark
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
