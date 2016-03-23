require 'rails_helper'

RSpec.describe "package_types/index", type: :view do
  before(:each) do
    assign(:package_types, [
      PackageType.create!(
        :nr => "Nr",
        :name => "Name"
      ),
      PackageType.create!(
        :nr => "Nr",
        :name => "Name"
      )
    ])
  end

  it "renders a list of package_types" do
    render
    assert_select "tr>td", :text => "Nr".to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
