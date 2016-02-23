require 'rails_helper'

RSpec.describe "permission_groups/index", type: :view do
  before(:each) do
    assign(:permission_groups, [
      PermissionGroup.create!(
        :name => "Name",
        :description => "Description"
      ),
      PermissionGroup.create!(
        :name => "Name",
        :description => "Description"
      )
    ])
  end

  it "renders a list of permission_groups" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
  end
end
