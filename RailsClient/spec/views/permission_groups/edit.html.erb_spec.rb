require 'rails_helper'

RSpec.describe "permission_groups/edit", type: :view do
  before(:each) do
    @permission_group = assign(:permission_group, PermissionGroup.create!(
      :name => "MyString",
      :description => "MyString"
    ))
  end

  it "renders the edit permission_group form" do
    render

    assert_select "form[action=?][method=?]", permission_group_path(@permission_group), "post" do

      assert_select "input#permission_group_name[name=?]", "permission_group[name]"

      assert_select "input#permission_group_description[name=?]", "permission_group[description]"
    end
  end
end
