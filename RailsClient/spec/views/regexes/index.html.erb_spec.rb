require 'rails_helper'

RSpec.describe "regexes/index", :type => :view do
  before(:each) do
    assign(:regexes, [
      Regex.create!(
        :name => "Name",
        :code => "Code",
        :prefix_length => 1,
        :prefix_string => "Prefix String",
        :type => 2,
        :suffix_length => 3,
        :suffix_string => 4,
        :regex_string => "Regex String",
        :localtion => nil
      ),
      Regex.create!(
        :name => "Name",
        :code => "Code",
        :prefix_length => 1,
        :prefix_string => "Prefix String",
        :type => 2,
        :suffix_length => 3,
        :suffix_string => 4,
        :regex_string => "Regex String",
        :localtion => nil
      )
    ])
  end

  it "renders a list of regexes" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Code".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Prefix String".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => "Regex String".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
