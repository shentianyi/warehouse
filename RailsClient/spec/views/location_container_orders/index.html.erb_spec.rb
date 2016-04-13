require 'rails_helper'

RSpec.describe "location_container_orders/index", type: :view do
  before(:each) do
    assign(:location_container_orders, [
      LocationContainerOrder.create!(
        :location_container_id => "Location Container",
        :order_id => "Order"
      ),
      LocationContainerOrder.create!(
        :location_container_id => "Location Container",
        :order_id => "Order"
      )
    ])
  end

  it "renders a list of location_container_orders" do
    render
    assert_select "tr>td", :text => "Location Container".to_s, :count => 2
    assert_select "tr>td", :text => "Order".to_s, :count => 2
  end
end
