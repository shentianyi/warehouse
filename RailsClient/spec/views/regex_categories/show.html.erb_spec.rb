require 'rails_helper'

RSpec.describe "regex_categories/show", :type => :view do
  before(:each) do
    @regex_category = assign(:regex_category, RegexCategory.create!(
      :name => "Name",
      :desc => "Desc",
      :type => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Desc/)
    expect(rendered).to match(/1/)
  end
end
