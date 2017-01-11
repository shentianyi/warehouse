require 'rails_helper'

RSpec.describe "order_cars/edit", type: :view do
  before(:each) do
    @order_car = assign(:order_car, OrderCar.create!(
      :nr => "MyString",
      :rfid_nr => "MyString",
      :status => 1,
      :whouse => nil
    ))
  end

  it "renders the edit order_car form" do
    render

    assert_select "form[action=?][method=?]", order_car_path(@order_car), "post" do

      assert_select "input#order_car_nr[name=?]", "order_car[nr]"

      assert_select "input#order_car_rfid_nr[name=?]", "order_car[rfid_nr]"

      assert_select "input#order_car_status[name=?]", "order_car[status]"

      assert_select "input#order_car_whouse_id[name=?]", "order_car[whouse_id]"
    end
  end
end
