require 'rails_helper'

RSpec.describe "location_container_orders/show", type: :view do
  before(:each) do
    @location_container_order = assign(:location_container_order, LocationContainerOrder.create!(
      :location_container_id => "Location Container",
      :order_id => "Order"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Location Container/)
    expect(rendered).to match(/Order/)
  end
end
