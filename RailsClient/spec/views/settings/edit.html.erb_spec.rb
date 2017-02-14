require 'rails_helper'

RSpec.describe "settings/edit", type: :view do
  before(:each) do
    @setting = assign(:setting, Setting.create!(
      :name => "MyString",
      :value => "MyString",
      :code => "MyString",
      :type => 1
    ))
  end

  it "renders the edit setting form" do
    render

    assert_select "form[action=?][method=?]", setting_path(@setting), "post" do

      assert_select "input#setting_name[name=?]", "setting[name]"

      assert_select "input#setting_value[name=?]", "setting[value]"

      assert_select "input#setting_code[name=?]", "setting[code]"

      assert_select "input#setting_type[name=?]", "setting[type]"
    end
  end
end
