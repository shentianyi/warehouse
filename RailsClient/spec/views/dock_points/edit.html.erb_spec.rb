require 'rails_helper'

RSpec.describe "dock_points/edit", type: :view do
  before(:each) do
    @dock_point = assign(:dock_point, DockPoint.create!(
      :nr => "MyString",
      :desc => "MyString"
    ))
  end

  it "renders the edit dock_point form" do
    render

    assert_select "form[action=?][method=?]", dock_point_path(@dock_point), "post" do

      assert_select "input#dock_point_nr[name=?]", "dock_point[nr]"

      assert_select "input#dock_point_desc[name=?]", "dock_point[desc]"
    end
  end
end
