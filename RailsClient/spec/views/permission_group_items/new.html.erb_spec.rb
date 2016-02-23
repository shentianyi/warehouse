require 'rails_helper'

RSpec.describe "permission_group_items/new", type: :view do
  before(:each) do
    assign(:permission_group_item, PermissionGroupItem.new(
      :permission => nil,
      :permission_group => nil
    ))
  end

  it "renders new permission_group_item form" do
    render

    assert_select "form[action=?][method=?]", permission_group_items_path, "post" do

      assert_select "input#permission_group_item_permission_id[name=?]", "permission_group_item[permission_id]"

      assert_select "input#permission_group_item_permission_group_id[name=?]", "permission_group_item[permission_group_id]"
    end
  end
end
