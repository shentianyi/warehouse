require 'rails_helper'

RSpec.describe "leds/new", :type => :view do
  before(:each) do
    assign(:modem_rest, Led.new(
      :id => "MyString",
      :signal_id => "MyString",
      :name => "MyString",
      :modem => nil,
      :position => nil
    ))
  end

  it "renders new led form" do
    render

    assert_select "form[action=?][method=?]", leds_path, "post" do

      assert_select "input#led_id[name=?]", "led[id]"

      assert_select "input#led_signal_id[name=?]", "led[signal_id]"

      assert_select "input#led_name[name=?]", "led[name]"

      assert_select "input#led_modem_id[name=?]", "led[modem_id]"

      assert_select "input#led_position_id[name=?]", "led[position_id]"
    end
  end
end
