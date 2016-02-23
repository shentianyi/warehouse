require 'rails_helper'

RSpec.describe "permission_groups/show", type: :view do
  before(:each) do
    @permission_group = assign(:permission_group, PermissionGroup.create!(
      :name => "Name",
      :description => "Description"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Description/)
  end
end
