require 'rails_helper'

RSpec.describe "regexes/show", :type => :view do
  before(:each) do
    @regex = assign(:regex, Regex.create!(
      :name => "Name",
      :code => "Code",
      :prefix_length => 1,
      :prefix_string => "Prefix String",
      :type => 2,
      :suffix_length => 3,
      :suffix_string => 4,
      :regex_string => "Regex String",
      :localtion => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Code/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Prefix String/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(/Regex String/)
    expect(rendered).to match(//)
  end
end
