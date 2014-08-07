require 'rails_helper'

RSpec.describe "pick_lists/edit", :type => :view do
  before(:each) do
    @pick_list = assign(:pick_list, PickList.create!(
      :id => "MyString",
      :user_id => "MyString"
    ))
  end

  it "renders the edit pick_list form" do
    render

    assert_select "form[action=?][method=?]", pick_list_path(@pick_list), "post" do

      assert_select "input#pick_list_id[name=?]", "pick_list[id]"

      assert_select "input#pick_list_user_id[name=?]", "pick_list[user_id]"
    end
  end
end
