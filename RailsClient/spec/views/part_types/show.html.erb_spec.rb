require 'rails_helper'

RSpec.describe "part_types/show", :type => :view do
  before(:each) do
    @part_type = assign(:part_type, PartType.create!(
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
  end
end
