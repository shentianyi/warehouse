require 'rails_helper'

RSpec.describe "leds/show", :type => :view do
  before(:each) do
    @led = assign(:modem_rest, Led.create!(
      :id => "Id",
      :signal_id => "Signal",
      :name => "Name",
      :modem => nil,
      :position => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Id/)
    expect(rendered).to match(/Signal/)
    expect(rendered).to match(/Name/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
