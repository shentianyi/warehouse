require 'rails_helper'

RSpec.describe "leds/index", :type => :view do
  before(:each) do
    assign(:leds, [
      Led.create!(
        :id => "Id",
        :signal_id => "Signal",
        :name => "Name",
        :modem => nil,
        :position => nil
      ),
      Led.create!(
        :id => "Id",
        :signal_id => "Signal",
        :name => "Name",
        :modem => nil,
        :position => nil
      )
    ])
  end

  it "renders a list of leds" do
    render
    assert_select "tr>td", :text => "Id".to_s, :count => 2
    assert_select "tr>td", :text => "Signal".to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
