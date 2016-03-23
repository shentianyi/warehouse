require 'rails_helper'

RSpec.describe "package_types/new", type: :view do
  before(:each) do
    assign(:package_type, PackageType.new(
      :nr => "MyString",
      :name => "MyString"
    ))
  end

  it "renders new package_type form" do
    render

    assert_select "form[action=?][method=?]", package_types_path, "post" do

      assert_select "input#package_type_nr[name=?]", "package_type[nr]"

      assert_select "input#package_type_name[name=?]", "package_type[name]"
    end
  end
end
