require 'rails_helper'

RSpec.describe "permissions/edit", type: :view do
  before(:each) do
    @permission = assign(:permission, Permission.create!(
      :name => "MyString",
      :description => "MyString"
    ))
  end

  it "renders the edit permission form" do
    render

    assert_select "form[action=?][method=?]", permission_path(@permission), "post" do

      assert_select "input#permission_name[name=?]", "permission[name]"

      assert_select "input#permission_description[name=?]", "permission[description]"
    end
  end
end
