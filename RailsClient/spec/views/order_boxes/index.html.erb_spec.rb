require 'rails_helper'

RSpec.describe "order_boxes/index", type: :view do
  before(:each) do
    assign(:order_boxes, [
      OrderBox.create!(
        :nr => "Nr",
        :rfid => "Rfid",
        :status => 1,
        :part => nil,
        :quantity => 1.5,
        :order_box_type => nil,
        :warehouse => nil,
        :source_warehouse => nil
      ),
      OrderBox.create!(
        :nr => "Nr",
        :rfid => "Rfid",
        :status => 1,
        :part => nil,
        :quantity => 1.5,
        :order_box_type => nil,
        :warehouse => nil,
        :source_warehouse => nil
      )
    ])
  end

  it "renders a list of order_boxes" do
    render
    assert_select "tr>td", :text => "Nr".to_s, :count => 2
    assert_select "tr>td", :text => "Rfid".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
