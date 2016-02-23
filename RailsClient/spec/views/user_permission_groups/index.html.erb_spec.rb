require 'rails_helper'

RSpec.describe "user_permission_groups/index", type: :view do
  before(:each) do
    assign(:user_permission_groups, [
      UserPermissionGroup.create!(
        :user => nil,
        :permission_group => nil
      ),
      UserPermissionGroup.create!(
        :user => nil,
        :permission_group => nil
      )
    ])
  end

  it "renders a list of user_permission_groups" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
