class AddStateToScrapListItems < ActiveRecord::Migration
  def change
    add_column :scrap_list_items, :state, :integer,default: ScrapListItemState::UNHANDLED
  end
end
