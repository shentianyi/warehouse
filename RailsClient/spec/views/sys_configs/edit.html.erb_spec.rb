require 'rails_helper'

RSpec.describe "sys_configs/edit", :type => :view do
  before(:each) do
    @sys_config = assign(:sys_config, SysConfig.create!(
      :key => "MyString",
      :value => "MyString",
      :name => "MyString"
    ))
  end

  it "renders the edit sys_config form" do
    render

    assert_select "form[action=?][method=?]", sys_config_path(@sys_config), "post" do

      assert_select "input#sys_config_key[name=?]", "sys_config[key]"

      assert_select "input#sys_config_value[name=?]", "sys_config[value]"

      assert_select "input#sys_config_name[name=?]", "sys_config[name]"
    end
  end
end
