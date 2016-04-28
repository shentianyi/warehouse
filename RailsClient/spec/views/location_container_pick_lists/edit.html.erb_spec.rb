require 'rails_helper'

RSpec.describe "location_container_pick_lists/edit", type: :view do
  before(:each) do
    @location_container_pick_list = assign(:location_container_pick_list, LocationContainerPickList.create!(
      :location_container_id => "MyString",
      :pick_list_id => "MyString"
    ))
  end

  it "renders the edit location_container_pick_list form" do
    render

    assert_select "form[action=?][method=?]", location_container_pick_list_path(@location_container_pick_list), "post" do

      assert_select "input#location_container_pick_list_location_container_id[name=?]", "location_container_pick_list[location_container_id]"

      assert_select "input#location_container_pick_list_pick_list_id[name=?]", "location_container_pick_list[pick_list_id]"
    end
  end
end
