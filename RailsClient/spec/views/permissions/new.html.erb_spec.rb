require 'rails_helper'

RSpec.describe "permissions/new", type: :view do
  before(:each) do
    assign(:permission, Permission.new(
      :name => "MyString",
      :description => "MyString"
    ))
  end

  it "renders new permission form" do
    render

    assert_select "form[action=?][method=?]", permissions_path, "post" do

      assert_select "input#permission_name[name=?]", "permission[name]"

      assert_select "input#permission_description[name=?]", "permission[description]"
    end
  end
end
