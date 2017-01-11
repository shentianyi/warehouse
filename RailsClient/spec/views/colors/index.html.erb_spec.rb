require 'rails_helper'

RSpec.describe "colors/index", type: :view do
  before(:each) do
    assign(:colors, [
      Color.create!(
        :nr => "Nr",
        :name => "Name",
        :short_name => "Short Name",
        :description => "Description"
      ),
      Color.create!(
        :nr => "Nr",
        :name => "Name",
        :short_name => "Short Name",
        :description => "Description"
      )
    ])
  end

  it "renders a list of colors" do
    render
    assert_select "tr>td", :text => "Nr".to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Short Name".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
  end
end
