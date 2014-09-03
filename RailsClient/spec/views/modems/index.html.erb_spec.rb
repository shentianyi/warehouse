require 'rails_helper'

RSpec.describe "modems/index", :type => :view do
  before(:each) do
    assign(:modems, [
      Modem.create!(
        :id => "Id",
        :name => "Name",
        :ip => "Ip"
      ),
      Modem.create!(
        :id => "Id",
        :name => "Name",
        :ip => "Ip"
      )
    ])
  end

  it "renders a list of modems" do
    render
    assert_select "tr>td", :text => "Id".to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Ip".to_s, :count => 2
  end
end
