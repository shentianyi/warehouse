require 'rails_helper'

RSpec.describe "colors/edit", type: :view do
  before(:each) do
    @color = assign(:color, Color.create!(
      :nr => "MyString",
      :name => "MyString",
      :short_name => "MyString",
      :description => "MyString"
    ))
  end

  it "renders the edit color form" do
    render

    assert_select "form[action=?][method=?]", color_path(@color), "post" do

      assert_select "input#color_nr[name=?]", "color[nr]"

      assert_select "input#color_name[name=?]", "color[name]"

      assert_select "input#color_short_name[name=?]", "color[short_name]"

      assert_select "input#color_description[name=?]", "color[description]"
    end
  end
end
