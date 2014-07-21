require 'rails_helper'

RSpec.describe "pick_items/index", :type => :view do
  before(:each) do
    assign(:pick_items, [
      PickItem.create!(
        :id => "Id",
        :pick_list_id => "Pick List",
        :order_item_id => "Order Item"
      ),
      PickItem.create!(
        :id => "Id",
        :pick_list_id => "Pick List",
        :order_item_id => "Order Item"
      )
    ])
  end

  it "renders a list of pick_items" do
    render
    assert_select "tr>td", :text => "Id".to_s, :count => 2
    assert_select "tr>td", :text => "Pick List".to_s, :count => 2
    assert_select "tr>td", :text => "Order Item".to_s, :count => 2
  end
end
