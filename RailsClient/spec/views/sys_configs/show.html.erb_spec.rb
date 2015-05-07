require 'rails_helper'

RSpec.describe "sys_configs/show", :type => :view do
  before(:each) do
    @sys_config = assign(:sys_config, SysConfig.create!(
      :key => "Key",
      :value => "Value",
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Key/)
    expect(rendered).to match(/Value/)
    expect(rendered).to match(/Name/)
  end
end
