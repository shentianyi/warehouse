require 'rails_helper'

RSpec.describe "wrappage_movement_items/index", type: :view do
  before(:each) do
    assign(:wrappage_movement_items, [
      WrappageMovementItem.create!(
        :src_location_id => "Src Location",
        :des_location_id => "Des Location",
        :qty => "Qty",
        :wrappage_move_type => "Wrappage Move Type",
        :user => nil,
        :sourceable_id => "Sourceable",
        :sourceable_type => "Sourceable Type",
        :extra_800_nos => "Extra 800 Nos",
        :extra_leoni_out_no => "Extra Leoni Out No"
      ),
      WrappageMovementItem.create!(
        :src_location_id => "Src Location",
        :des_location_id => "Des Location",
        :qty => "Qty",
        :wrappage_move_type => "Wrappage Move Type",
        :user => nil,
        :sourceable_id => "Sourceable",
        :sourceable_type => "Sourceable Type",
        :extra_800_nos => "Extra 800 Nos",
        :extra_leoni_out_no => "Extra Leoni Out No"
      )
    ])
  end

  it "renders a list of wrappage_movement_items" do
    render
    assert_select "tr>td", :text => "Src Location".to_s, :count => 2
    assert_select "tr>td", :text => "Des Location".to_s, :count => 2
    assert_select "tr>td", :text => "Qty".to_s, :count => 2
    assert_select "tr>td", :text => "Wrappage Move Type".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Sourceable".to_s, :count => 2
    assert_select "tr>td", :text => "Sourceable Type".to_s, :count => 2
    assert_select "tr>td", :text => "Extra 800 Nos".to_s, :count => 2
    assert_select "tr>td", :text => "Extra Leoni Out No".to_s, :count => 2
  end
end
