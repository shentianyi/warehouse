require 'rails_helper'

RSpec.describe "regex_categories/index", :type => :view do
  before(:each) do
    assign(:regex_categories, [
      RegexCategory.create!(
        :name => "Name",
        :desc => "Desc",
        :type => 1
      ),
      RegexCategory.create!(
        :name => "Name",
        :desc => "Desc",
        :type => 1
      )
    ])
  end

  it "renders a list of regex_categories" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Desc".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
