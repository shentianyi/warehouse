require 'rails_helper'

RSpec.describe "scrap_list_items/index", type: :view do
  before(:each) do
    assign(:scrap_list_items, [
      ScrapListItem.create!(
        :scrap_list_id => 1,
        :part_id => 2
      ),
      ScrapListItem.create!(
        :scrap_list_id => 1,
        :part_id => 2
      )
    ])
  end

  it "renders a list of scrap_list_items" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
