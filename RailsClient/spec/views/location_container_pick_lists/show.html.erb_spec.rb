require 'rails_helper'

RSpec.describe "location_container_pick_lists/show", type: :view do
  before(:each) do
    @location_container_pick_list = assign(:location_container_pick_list, LocationContainerPickList.create!(
      :location_container_id => "Location Container",
      :pick_list_id => "Pick List"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Location Container/)
    expect(rendered).to match(/Pick List/)
  end
end
