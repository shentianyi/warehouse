require 'rails_helper'

RSpec.describe "modems/show", :type => :view do
  before(:each) do
    @modem = assign(:modem, Modem.create!(
      :id => "Id",
      :name => "Name",
      :ip => "Ip"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Id/)
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Ip/)
  end
end
