class WrappageService
  def self.move_wrappage plc, src, des
    # msg=Message.new
    # begin
      if (package=plc.package)
        params={
            partNr: package.part.wrappage.mirror.id,
            qty: (package.quantity/package.part.part_wrappage.capacity).to_i + (package.quantity%package.part.part_wrappage.capacity > 0 ? 1 : 0).to_i,
            employee_id: package.user_id,
            fromWh: src.default_whouse.id,
            fromPosition: src.default_whouse.default_position.id,
            toWh: des.default_whouse.id,
            toPosition: des.default_whouse.default_position.id
        }
        WhouseService.new.move(params)
      end
    # rescue => e
    #   msg.result=false
    #   msg.content = e.message
    # end
    # return msg
  end


end