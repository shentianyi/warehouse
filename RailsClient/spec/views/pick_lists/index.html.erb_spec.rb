require 'rails_helper'

RSpec.describe "pick_lists/index", :type => :view do
  before(:each) do
    assign(:pick_lists, [
      PickList.create!(
        :id => "Id",
        :user_id => "User"
      ),
      PickList.create!(
        :id => "Id",
        :user_id => "User"
      )
    ])
  end

  it "renders a list of pick_lists" do
    render
    assert_select "tr>td", :text => "Id".to_s, :count => 2
    assert_select "tr>td", :text => "User".to_s, :count => 2
  end
end
