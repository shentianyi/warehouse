class BackPartItem < ActiveRecord::Base
  include Extensions::UUID

  belongs_to :back_part
  belongs_to :part
  belongs_to :whouse
  belongs_to :position

  def generate_id
    "BPI#{Time.now.to_milli}"
  end

  def stock_move(user, move_list_id, pid=nil)
    src_location=self.back_part.src_location
    des_location=self.back_part.des_location
    if src_location.id==(Location.find_by_nr('JXJX').id)
      params={
          partNr: self.part.id,
          qty: self.qty,
          packageId: (package.id if pid),
          employee_id: user.id,
          fromWh: self.whouse_id,
          fromPosition: self.position_id,
          toWh: des_location.whouses.first.id,
          toPosition: des_location.whouses.first.default_position.id
      }
    else
      params={
          partNr: self.part.id,
          qty: self.qty,
          packageId: (package.id if pid),
          employee_id: user.id,
          fromWh: src_location.whouses.first.id,
          fromPosition: src_location.whouses.first.default_position.id,
          toWh: self.whouse_id,
          toPosition: self.position_id
      }
    end

    WhouseService.new.move(params)
    params[:movement_list_id]=move_list_id
    MovementSource.create(params)
  end

end
