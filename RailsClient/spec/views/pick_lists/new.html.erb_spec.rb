require 'rails_helper'

RSpec.describe "pick_lists/new", :type => :view do
  before(:each) do
    assign(:pick_list, PickList.new(
      :id => "MyString",
      :user_id => "MyString"
    ))
  end

  it "renders new pick_list form" do
    render

    assert_select "form[action=?][method=?]", pick_lists_path, "post" do

      assert_select "input#pick_list_id[name=?]", "pick_list[id]"

      assert_select "input#pick_list_user_id[name=?]", "pick_list[user_id]"
    end
  end
end
