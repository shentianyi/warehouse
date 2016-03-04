require 'rails_helper'

RSpec.describe "order_box_types/new", type: :view do
  before(:each) do
    assign(:order_box_type, OrderBoxType.new(
      :name => "MyString",
      :description => "MyString",
      :weight => 1.5
    ))
  end

  it "renders new order_box_type form" do
    render

    assert_select "form[action=?][method=?]", order_box_types_path, "post" do

      assert_select "input#order_box_type_name[name=?]", "order_box_type[name]"

      assert_select "input#order_box_type_description[name=?]", "order_box_type[description]"

      assert_select "input#order_box_type_weight[name=?]", "order_box_type[weight]"
    end
  end
end
