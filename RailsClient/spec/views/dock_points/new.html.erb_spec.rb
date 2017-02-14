require 'rails_helper'

RSpec.describe "dock_points/new", type: :view do
  before(:each) do
    assign(:dock_point, DockPoint.new(
      :nr => "MyString",
      :desc => "MyString"
    ))
  end

  it "renders new dock_point form" do
    render

    assert_select "form[action=?][method=?]", dock_points_path, "post" do

      assert_select "input#dock_point_nr[name=?]", "dock_point[nr]"

      assert_select "input#dock_point_desc[name=?]", "dock_point[desc]"
    end
  end
end
