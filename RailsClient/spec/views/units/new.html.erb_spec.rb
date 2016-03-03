require 'rails_helper'

RSpec.describe "units/new", type: :view do
  before(:each) do
    assign(:unit, Unit.new(
      :nr => "MyString",
      :name => "MyString",
      :short_name => "MyString",
      :description => "MyString"
    ))
  end

  it "renders new unit form" do
    render

    assert_select "form[action=?][method=?]", units_path, "post" do

      assert_select "input#unit_nr[name=?]", "unit[nr]"

      assert_select "input#unit_name[name=?]", "unit[name]"

      assert_select "input#unit_short_name[name=?]", "unit[short_name]"

      assert_select "input#unit_description[name=?]", "unit[description]"
    end
  end
end
