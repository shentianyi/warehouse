require 'rails_helper'

RSpec.describe "location_container_pick_lists/index", type: :view do
  before(:each) do
    assign(:location_container_pick_lists, [
      LocationContainerPickList.create!(
        :location_container_id => "Location Container",
        :pick_list_id => "Pick List"
      ),
      LocationContainerPickList.create!(
        :location_container_id => "Location Container",
        :pick_list_id => "Pick List"
      )
    ])
  end

  it "renders a list of location_container_pick_lists" do
    render
    assert_select "tr>td", :text => "Location Container".to_s, :count => 2
    assert_select "tr>td", :text => "Pick List".to_s, :count => 2
  end
end
