require 'rails_helper'

RSpec.describe "sys_configs/index", :type => :view do
  before(:each) do
    assign(:sys_configs, [
      SysConfig.create!(
        :key => "Key",
        :value => "Value",
        :name => "Name"
      ),
      SysConfig.create!(
        :key => "Key",
        :value => "Value",
        :name => "Name"
      )
    ])
  end

  it "renders a list of sys_configs" do
    render
    assert_select "tr>td", :text => "Key".to_s, :count => 2
    assert_select "tr>td", :text => "Value".to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
