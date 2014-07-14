require 'rails_helper'

RSpec.describe "regexes/edit", :type => :view do
  before(:each) do
    @regex = assign(:regex, Regex.create!(
      :name => "MyString",
      :code => "MyString",
      :prefix_length => 1,
      :prefix_string => "MyString",
      :type => 1,
      :suffix_length => 1,
      :suffix_string => 1,
      :regex_string => "MyString",
      :localtion => nil
    ))
  end

  it "renders the edit regex form" do
    render

    assert_select "form[action=?][method=?]", regex_path(@regex), "post" do

      assert_select "input#regex_name[name=?]", "regex[name]"

      assert_select "input#regex_code[name=?]", "regex[code]"

      assert_select "input#regex_prefix_length[name=?]", "regex[prefix_length]"

      assert_select "input#regex_prefix_string[name=?]", "regex[prefix_string]"

      assert_select "input#regex_type[name=?]", "regex[type]"

      assert_select "input#regex_suffix_length[name=?]", "regex[suffix_length]"

      assert_select "input#regex_suffix_string[name=?]", "regex[suffix_string]"

      assert_select "input#regex_regex_string[name=?]", "regex[regex_string]"

      assert_select "input#regex_localtion_id[name=?]", "regex[localtion_id]"
    end
  end
end
