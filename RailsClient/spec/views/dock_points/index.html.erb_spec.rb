require 'rails_helper'

RSpec.describe "dock_points/index", type: :view do
  before(:each) do
    assign(:dock_points, [
      DockPoint.create!(
        :nr => "Nr",
        :desc => "Desc"
      ),
      DockPoint.create!(
        :nr => "Nr",
        :desc => "Desc"
      )
    ])
  end

  it "renders a list of dock_points" do
    render
    assert_select "tr>td", :text => "Nr".to_s, :count => 2
    assert_select "tr>td", :text => "Desc".to_s, :count => 2
  end
end
