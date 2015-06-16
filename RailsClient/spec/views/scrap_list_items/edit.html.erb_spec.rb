require 'rails_helper'

RSpec.describe "scrap_list_items/edit", type: :view do
  before(:each) do
    @scrap_list_item = assign(:scrap_list_item, ScrapListItem.create!(
      :scrap_list_id => 1,
      :part_id => 1
    ))
  end

  it "renders the edit scrap_list_item form" do
    render

    assert_select "form[action=?][method=?]", scrap_list_item_path(@scrap_list_item), "post" do

      assert_select "input#scrap_list_item_scrap_list_id[name=?]", "scrap_list_item[scrap_list_id]"

      assert_select "input#scrap_list_item_part_id[name=?]", "scrap_list_item[part_id]"
    end
  end
end
