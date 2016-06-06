require 'rails_helper'

RSpec.describe "wrappage_movement_items/show", type: :view do
  before(:each) do
    @wrappage_movement_item = assign(:wrappage_movement_item, WrappageMovementItem.create!(
      :src_location_id => "Src Location",
      :des_location_id => "Des Location",
      :qty => "Qty",
      :wrappage_move_type => "Wrappage Move Type",
      :user => nil,
      :sourceable_id => "Sourceable",
      :sourceable_type => "Sourceable Type",
      :extra_800_nos => "Extra 800 Nos",
      :extra_leoni_out_no => "Extra Leoni Out No"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Src Location/)
    expect(rendered).to match(/Des Location/)
    expect(rendered).to match(/Qty/)
    expect(rendered).to match(/Wrappage Move Type/)
    expect(rendered).to match(//)
    expect(rendered).to match(/Sourceable/)
    expect(rendered).to match(/Sourceable Type/)
    expect(rendered).to match(/Extra 800 Nos/)
    expect(rendered).to match(/Extra Leoni Out No/)
  end
end
