require 'rails_helper'

RSpec.describe "back_parts/show", type: :view do
  before(:each) do
    @back_part = assign(:back_part, BackPart.create!(
      :builder => "Builder",
      :des_location_id => "Des Location",
      :src_location_id => "Src Location"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Builder/)
    expect(rendered).to match(/Des Location/)
    expect(rendered).to match(/Src Location/)
  end
end
