require 'rails_helper'

RSpec.describe "user_permission_groups/new", type: :view do
  before(:each) do
    assign(:user_permission_group, UserPermissionGroup.new(
      :user => nil,
      :permission_group => nil
    ))
  end

  it "renders new user_permission_group form" do
    render

    assert_select "form[action=?][method=?]", user_permission_groups_path, "post" do

      assert_select "input#user_permission_group_user_id[name=?]", "user_permission_group[user_id]"

      assert_select "input#user_permission_group_permission_group_id[name=?]", "user_permission_group[permission_group_id]"
    end
  end
end
