require 'rails_helper'

RSpec.describe "units/index", type: :view do
  before(:each) do
    assign(:units, [
      Unit.create!(
        :nr => "Nr",
        :name => "Name",
        :short_name => "Short Name",
        :description => "Description"
      ),
      Unit.create!(
        :nr => "Nr",
        :name => "Name",
        :short_name => "Short Name",
        :description => "Description"
      )
    ])
  end

  it "renders a list of units" do
    render
    assert_select "tr>td", :text => "Nr".to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Short Name".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
  end
end
