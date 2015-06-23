class ScrapListItem < ActiveRecord::Base
  belongs_to :scrap_list

  def scrap
    params={
        partNr: self.part_id,
        qty: self.quantity,
        toWh: 'BaofeiKu',
        toPosition:'BaofeiWeizhi',
        fromWh:'3EX'
    }
    WhouseService.new.move(params)
    self.update_attributes(state:ScrapListItemState::HANDLED)
  end
end
