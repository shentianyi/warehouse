require 'rails_helper'

RSpec.describe "permission_groups/new", type: :view do
  before(:each) do
    assign(:permission_group, PermissionGroup.new(
      :name => "MyString",
      :description => "MyString"
    ))
  end

  it "renders new permission_group form" do
    render

    assert_select "form[action=?][method=?]", permission_groups_path, "post" do

      assert_select "input#permission_group_name[name=?]", "permission_group[name]"

      assert_select "input#permission_group_description[name=?]", "permission_group[description]"
    end
  end
end
