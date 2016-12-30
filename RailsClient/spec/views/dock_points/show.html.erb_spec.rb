require 'rails_helper'

RSpec.describe "dock_points/show", type: :view do
  before(:each) do
    @dock_point = assign(:dock_point, DockPoint.create!(
      :nr => "Nr",
      :desc => "Desc"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Nr/)
    expect(rendered).to match(/Desc/)
  end
end
