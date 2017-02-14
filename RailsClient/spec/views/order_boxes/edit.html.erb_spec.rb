require 'rails_helper'

RSpec.describe "order_boxes/edit", type: :view do
  before(:each) do
    @order_box = assign(:order_box, OrderBox.create!(
      :nr => "MyString",
      :rfid => "MyString",
      :status => 1,
      :part => nil,
      :quantity => 1.5,
      :order_box_type => nil,
      :warehouse => nil,
      :source_warehouse => nil
    ))
  end

  it "renders the edit order_box form" do
    render

    assert_select "form[action=?][method=?]", order_box_path(@order_box), "post" do

      assert_select "input#order_box_nr[name=?]", "order_box[nr]"

      assert_select "input#order_box_rfid[name=?]", "order_box[rfid]"

      assert_select "input#order_box_status[name=?]", "order_box[status]"

      assert_select "input#order_box_part_id[name=?]", "order_box[part_id]"

      assert_select "input#order_box_quantity[name=?]", "order_box[quantity]"

      assert_select "input#order_box_order_box_type_id[name=?]", "order_box[order_box_type_id]"

      assert_select "input#order_box_warehouse_id[name=?]", "order_box[warehouse_id]"

      assert_select "input#order_box_source_warehouse_id[name=?]", "order_box[source_warehouse_id]"
    end
  end
end
