require 'rails_helper'

RSpec.describe "back_part_items/new", type: :view do
  before(:each) do
    assign(:back_part_item, BackPartItem.new(
      :back_part => nil,
      :part => nil,
      :qty => 1.5,
      :back_reason => "MyString",
      :has_sample => "MyString",
      :remark => "MyString",
      :whouse => nil,
      :position => nil
    ))
  end

  it "renders new back_part_item form" do
    render

    assert_select "form[action=?][method=?]", back_part_items_path, "post" do

      assert_select "input#back_part_item_back_part_id[name=?]", "back_part_item[back_part_id]"

      assert_select "input#back_part_item_part_id[name=?]", "back_part_item[part_id]"

      assert_select "input#back_part_item_qty[name=?]", "back_part_item[qty]"

      assert_select "input#back_part_item_back_reason[name=?]", "back_part_item[back_reason]"

      assert_select "input#back_part_item_has_sample[name=?]", "back_part_item[has_sample]"

      assert_select "input#back_part_item_remark[name=?]", "back_part_item[remark]"

      assert_select "input#back_part_item_whouse_id[name=?]", "back_part_item[whouse_id]"

      assert_select "input#back_part_item_position_id[name=?]", "back_part_item[position_id]"
    end
  end
end
