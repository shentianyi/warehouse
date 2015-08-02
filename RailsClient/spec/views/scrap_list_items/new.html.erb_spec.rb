require 'rails_helper'

RSpec.describe "scrap_list_items/new", type: :view do
  before(:each) do
    assign(:scrap_list_item, ScrapListItem.new(
      :scrap_list_id => 1,
      :part_id => 1
    ))
  end

  it "renders new scrap_list_item form" do
    render

    assert_select "form[action=?][method=?]", scrap_list_items_path, "post" do

      assert_select "input#scrap_list_item_scrap_list_id[name=?]", "scrap_list_item[scrap_list_id]"

      assert_select "input#scrap_list_item_part_id[name=?]", "scrap_list_item[part_id]"
    end
  end
end
