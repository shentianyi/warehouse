require 'rails_helper'

RSpec.describe "settings/new", type: :view do
  before(:each) do
    assign(:setting, Setting.new(
      :name => "MyString",
      :value => "MyString",
      :code => "MyString",
      :type => 1
    ))
  end

  it "renders new setting form" do
    render

    assert_select "form[action=?][method=?]", settings_path, "post" do

      assert_select "input#setting_name[name=?]", "setting[name]"

      assert_select "input#setting_value[name=?]", "setting[value]"

      assert_select "input#setting_code[name=?]", "setting[code]"

      assert_select "input#setting_type[name=?]", "setting[type]"
    end
  end
end
