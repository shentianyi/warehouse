require 'rails_helper'

RSpec.describe "back_parts/index", type: :view do
  before(:each) do
    assign(:back_parts, [
      BackPart.create!(
        :builder => "Builder",
        :des_location_id => "Des Location",
        :src_location_id => "Src Location"
      ),
      BackPart.create!(
        :builder => "Builder",
        :des_location_id => "Des Location",
        :src_location_id => "Src Location"
      )
    ])
  end

  it "renders a list of back_parts" do
    render
    assert_select "tr>td", :text => "Builder".to_s, :count => 2
    assert_select "tr>td", :text => "Des Location".to_s, :count => 2
    assert_select "tr>td", :text => "Src Location".to_s, :count => 2
  end
end
