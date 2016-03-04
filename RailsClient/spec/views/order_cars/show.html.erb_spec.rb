require 'rails_helper'

RSpec.describe "order_cars/show", type: :view do
  before(:each) do
    @order_car = assign(:order_car, OrderCar.create!(
      :nr => "Nr",
      :rfid_nr => "Rfid Nr",
      :status => 1,
      :whouse => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Nr/)
    expect(rendered).to match(/Rfid Nr/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(//)
  end
end
