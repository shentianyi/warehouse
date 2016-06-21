require 'rails_helper'

RSpec.describe "wrappage_movement_items/new", type: :view do
  before(:each) do
    assign(:wrappage_movement_item, WrappageMovementItem.new(
      :src_location_id => "MyString",
      :des_location_id => "MyString",
      :qty => "MyString",
      :wrappage_move_type => "MyString",
      :user => nil,
      :sourceable_id => "MyString",
      :sourceable_type => "MyString",
      :extra_800_nos => "MyString",
      :extra_leoni_out_no => "MyString"
    ))
  end

  it "renders new wrappage_movement_item form" do
    render

    assert_select "form[action=?][method=?]", wrappage_movement_items_path, "post" do

      assert_select "input#wrappage_movement_item_src_location_id[name=?]", "wrappage_movement_item[src_location_id]"

      assert_select "input#wrappage_movement_item_des_location_id[name=?]", "wrappage_movement_item[des_location_id]"

      assert_select "input#wrappage_movement_item_qty[name=?]", "wrappage_movement_item[qty]"

      assert_select "input#wrappage_movement_item_wrappage_move_type[name=?]", "wrappage_movement_item[wrappage_move_type]"

      assert_select "input#wrappage_movement_item_user_id[name=?]", "wrappage_movement_item[user_id]"

      assert_select "input#wrappage_movement_item_sourceable_id[name=?]", "wrappage_movement_item[sourceable_id]"

      assert_select "input#wrappage_movement_item_sourceable_type[name=?]", "wrappage_movement_item[sourceable_type]"

      assert_select "input#wrappage_movement_item_extra_800_nos[name=?]", "wrappage_movement_item[extra_800_nos]"

      assert_select "input#wrappage_movement_item_extra_leoni_out_no[name=?]", "wrappage_movement_item[extra_leoni_out_no]"
    end
  end
end
