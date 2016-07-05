require 'rails_helper'

RSpec.describe "wrappages/show", type: :view do
  before(:each) do
    @wrappage = assign(:wrappage, Wrappage.create!(
      :nr => "Nr",
      :name => "Name",
      :desc => "Desc"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Nr/)
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Desc/)
  end
end
