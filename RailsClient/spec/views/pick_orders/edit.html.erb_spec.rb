require 'rails_helper'

RSpec.describe "pick_orders/edit", type: :view do
  before(:each) do
    @pick_order = assign(:pick_order, PickOrder.create!(
      :order => nil,
      :pick_list => nil
    ))
  end

  it "renders the edit pick_order form" do
    render

    assert_select "form[action=?][method=?]", pick_order_path(@pick_order), "post" do

      assert_select "input#pick_order_order_id[name=?]", "pick_order[order_id]"

      assert_select "input#pick_order_pick_list_id[name=?]", "pick_order[pick_list_id]"
    end
  end
end
