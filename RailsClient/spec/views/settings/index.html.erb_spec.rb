require 'rails_helper'

RSpec.describe "settings/index", type: :view do
  before(:each) do
    assign(:settings, [
      Setting.create!(
        :name => "Name",
        :value => "Value",
        :code => "Code",
        :type => 1
      ),
      Setting.create!(
        :name => "Name",
        :value => "Value",
        :code => "Code",
        :type => 1
      )
    ])
  end

  it "renders a list of settings" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Value".to_s, :count => 2
    assert_select "tr>td", :text => "Code".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
