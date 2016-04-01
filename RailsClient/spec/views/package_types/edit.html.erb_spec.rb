require 'rails_helper'

RSpec.describe "package_types/edit", type: :view do
  before(:each) do
    @package_type = assign(:package_type, PackageType.create!(
      :nr => "MyString",
      :name => "MyString"
    ))
  end

  it "renders the edit package_type form" do
    render

    assert_select "form[action=?][method=?]", package_type_path(@package_type), "post" do

      assert_select "input#package_type_nr[name=?]", "package_type[nr]"

      assert_select "input#package_type_name[name=?]", "package_type[name]"
    end
  end
end
