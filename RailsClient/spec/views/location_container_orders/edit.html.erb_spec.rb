require 'rails_helper'

RSpec.describe "location_container_orders/edit", type: :view do
  before(:each) do
    @location_container_order = assign(:location_container_order, LocationContainerOrder.create!(
      :location_container_id => "MyString",
      :order_id => "MyString"
    ))
  end

  it "renders the edit location_container_order form" do
    render

    assert_select "form[action=?][method=?]", location_container_order_path(@location_container_order), "post" do

      assert_select "input#location_container_order_location_container_id[name=?]", "location_container_order[location_container_id]"

      assert_select "input#location_container_order_order_id[name=?]", "location_container_order[order_id]"
    end
  end
end
