class ScrapListItem < ActiveRecord::Base
  belongs_to :scrap_list

  def scrap

    params={
        partNr: self.part_id,
        qty: self.quantity,
        toWh: self.scrap_list.dse_warehouse,
        fromWh:self.scrap_list.src_warehouse
    }

    WhouseService.new.move(params)
    self.update_attributes(state:ScrapListItemState::HANDLED)
  end
end
