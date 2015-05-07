require 'rails_helper'

RSpec.describe "sys_configs/new", :type => :view do
  before(:each) do
    assign(:sys_config, SysConfig.new(
      :key => "MyString",
      :value => "MyString",
      :name => "MyString"
    ))
  end

  it "renders new sys_config form" do
    render

    assert_select "form[action=?][method=?]", sys_configs_path, "post" do

      assert_select "input#sys_config_key[name=?]", "sys_config[key]"

      assert_select "input#sys_config_value[name=?]", "sys_config[value]"

      assert_select "input#sys_config_name[name=?]", "sys_config[name]"
    end
  end
end
