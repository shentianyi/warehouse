require 'rails_helper'

RSpec.describe "inventory_lists/edit", type: :view do
  before(:each) do
    @inventory_list = assign(:inventory_list, InventoryList.create!(
      :name => "MyString",
      :state => 1,
      :whouse_id => "MyString",
      :user_id => "MyString"
    ))
  end

  it "renders the edit inventory_list form" do
    render

    assert_select "form[action=?][method=?]", inventory_list_path(@inventory_list), "post" do

      assert_select "input#inventory_list_name[name=?]", "inventory_list[name]"

      assert_select "input#inventory_list_state[name=?]", "inventory_list[state]"

      assert_select "input#inventory_list_whouse_id[name=?]", "inventory_list[whouse_id]"

      assert_select "input#inventory_list_user_id[name=?]", "inventory_list[user_id]"
    end
  end
end
