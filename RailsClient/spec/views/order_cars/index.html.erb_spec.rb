require 'rails_helper'

RSpec.describe "order_cars/index", type: :view do
  before(:each) do
    assign(:order_cars, [
      OrderCar.create!(
        :nr => "Nr",
        :rfid_nr => "Rfid Nr",
        :status => 1,
        :whouse => nil
      ),
      OrderCar.create!(
        :nr => "Nr",
        :rfid_nr => "Rfid Nr",
        :status => 1,
        :whouse => nil
      )
    ])
  end

  it "renders a list of order_cars" do
    render
    assert_select "tr>td", :text => "Nr".to_s, :count => 2
    assert_select "tr>td", :text => "Rfid Nr".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
