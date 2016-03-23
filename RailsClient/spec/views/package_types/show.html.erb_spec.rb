require 'rails_helper'

RSpec.describe "package_types/show", type: :view do
  before(:each) do
    @package_type = assign(:package_type, PackageType.create!(
      :nr => "Nr",
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Nr/)
    expect(rendered).to match(/Name/)
  end
end
