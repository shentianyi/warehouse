require 'rails_helper'

RSpec.describe "user_permission_groups/edit", type: :view do
  before(:each) do
    @user_permission_group = assign(:user_permission_group, UserPermissionGroup.create!(
      :user => nil,
      :permission_group => nil
    ))
  end

  it "renders the edit user_permission_group form" do
    render

    assert_select "form[action=?][method=?]", user_permission_group_path(@user_permission_group), "post" do

      assert_select "input#user_permission_group_user_id[name=?]", "user_permission_group[user_id]"

      assert_select "input#user_permission_group_permission_group_id[name=?]", "user_permission_group[permission_group_id]"
    end
  end
end
