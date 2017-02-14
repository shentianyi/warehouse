require 'rails_helper'

RSpec.describe "pick_orders/index", type: :view do
  before(:each) do
    assign(:pick_orders, [
      PickOrder.create!(
        :order => nil,
        :pick_list => nil
      ),
      PickOrder.create!(
        :order => nil,
        :pick_list => nil
      )
    ])
  end

  it "renders a list of pick_orders" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
