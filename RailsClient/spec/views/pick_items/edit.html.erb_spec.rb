require 'rails_helper'

RSpec.describe "pick_items/edit", :type => :view do
  before(:each) do
    @pick_item = assign(:pick_item, PickItem.create!(
      :id => "MyString",
      :pick_list_id => "MyString",
      :order_item_id => "MyString"
    ))
  end

  it "renders the edit pick_item form" do
    render

    assert_select "form[action=?][method=?]", pick_item_path(@pick_item), "post" do

      assert_select "input#pick_item_id[name=?]", "pick_item[id]"

      assert_select "input#pick_item_pick_list_id[name=?]", "pick_item[pick_list_id]"

      assert_select "input#pick_item_order_item_id[name=?]", "pick_item[order_item_id]"
    end
  end
end
