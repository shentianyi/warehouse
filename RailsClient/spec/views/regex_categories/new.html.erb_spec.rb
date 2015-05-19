require 'rails_helper'

RSpec.describe "regex_categories/new", :type => :view do
  before(:each) do
    assign(:regex_category, RegexCategory.new(
      :name => "MyString",
      :desc => "MyString",
      :type => 1
    ))
  end

  it "renders new regex_category form" do
    render

    assert_select "form[action=?][method=?]", regex_categories_path, "post" do

      assert_select "input#regex_category_name[name=?]", "regex_category[name]"

      assert_select "input#regex_category_desc[name=?]", "regex_category[desc]"

      assert_select "input#regex_category_type[name=?]", "regex_category[type]"
    end
  end
end
