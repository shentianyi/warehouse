require 'rails_helper'

RSpec.describe "permissions/index", type: :view do
  before(:each) do
    assign(:permissions, [
      Permission.create!(
        :name => "Name",
        :description => "Description"
      ),
      Permission.create!(
        :name => "Name",
        :description => "Description"
      )
    ])
  end

  it "renders a list of permissions" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
  end
end
