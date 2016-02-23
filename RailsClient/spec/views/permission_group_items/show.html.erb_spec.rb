require 'rails_helper'

RSpec.describe "permission_group_items/show", type: :view do
  before(:each) do
    @permission_group_item = assign(:permission_group_item, PermissionGroupItem.create!(
      :permission => nil,
      :permission_group => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
