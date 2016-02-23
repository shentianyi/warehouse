require 'rails_helper'

RSpec.describe "permission_group_items/index", type: :view do
  before(:each) do
    assign(:permission_group_items, [
      PermissionGroupItem.create!(
        :permission => nil,
        :permission_group => nil
      ),
      PermissionGroupItem.create!(
        :permission => nil,
        :permission_group => nil
      )
    ])
  end

  it "renders a list of permission_group_items" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
