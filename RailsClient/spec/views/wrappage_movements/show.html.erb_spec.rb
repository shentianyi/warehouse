require 'rails_helper'

RSpec.describe "wrappage_movements/show", type: :view do
  before(:each) do
    @wrappage_movement = assign(:wrappage_movement, WrappageMovement.create!(
      :move_date => "Move Date",
      :package_type => nil,
      :user => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Move Date/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
