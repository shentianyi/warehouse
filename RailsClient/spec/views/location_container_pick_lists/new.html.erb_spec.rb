require 'rails_helper'

RSpec.describe "location_container_pick_lists/new", type: :view do
  before(:each) do
    assign(:location_container_pick_list, LocationContainerPickList.new(
      :location_container_id => "MyString",
      :pick_list_id => "MyString"
    ))
  end

  it "renders new location_container_pick_list form" do
    render

    assert_select "form[action=?][method=?]", location_container_pick_lists_path, "post" do

      assert_select "input#location_container_pick_list_location_container_id[name=?]", "location_container_pick_list[location_container_id]"

      assert_select "input#location_container_pick_list_pick_list_id[name=?]", "location_container_pick_list[pick_list_id]"
    end
  end
end
