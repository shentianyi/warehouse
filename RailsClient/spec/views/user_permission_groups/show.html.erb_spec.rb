require 'rails_helper'

RSpec.describe "user_permission_groups/show", type: :view do
  before(:each) do
    @user_permission_group = assign(:user_permission_group, UserPermissionGroup.create!(
      :user => nil,
      :permission_group => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
