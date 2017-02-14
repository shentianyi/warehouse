require 'rails_helper'

RSpec.describe "pick_orders/new", type: :view do
  before(:each) do
    assign(:pick_order, PickOrder.new(
      :order => nil,
      :pick_list => nil
    ))
  end

  it "renders new pick_order form" do
    render

    assert_select "form[action=?][method=?]", pick_orders_path, "post" do

      assert_select "input#pick_order_order_id[name=?]", "pick_order[order_id]"

      assert_select "input#pick_order_pick_list_id[name=?]", "pick_order[pick_list_id]"
    end
  end
end
