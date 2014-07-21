require 'rails_helper'

RSpec.describe "pick_items/show", :type => :view do
  before(:each) do
    @pick_item = assign(:pick_item, PickItem.create!(
      :id => "Id",
      :pick_list_id => "Pick List",
      :order_item_id => "Order Item"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Id/)
    expect(rendered).to match(/Pick List/)
    expect(rendered).to match(/Order Item/)
  end
end
