require 'rails_helper'

RSpec.describe "settings/show", type: :view do
  before(:each) do
    @setting = assign(:setting, Setting.create!(
      :name => "Name",
      :value => "Value",
      :code => "Code",
      :type => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Value/)
    expect(rendered).to match(/Code/)
    expect(rendered).to match(/1/)
  end
end
