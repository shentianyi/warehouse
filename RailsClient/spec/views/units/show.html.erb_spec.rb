require 'rails_helper'

RSpec.describe "units/show", type: :view do
  before(:each) do
    @unit = assign(:unit, Unit.create!(
      :nr => "Nr",
      :name => "Name",
      :short_name => "Short Name",
      :description => "Description"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Nr/)
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Short Name/)
    expect(rendered).to match(/Description/)
  end
end
