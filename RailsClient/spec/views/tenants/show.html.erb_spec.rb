require 'rails_helper'

RSpec.describe "tenants/show", type: :view do
  before(:each) do
    @tenant = assign(:tenant, Tenant.create!(
      :name => "Name",
      :code => "Code",
      :address => "Address",
      :email => "Email",
      :tel => "Tel",
      :website => "Website",
      :type => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Code/)
    expect(rendered).to match(/Address/)
    expect(rendered).to match(/Email/)
    expect(rendered).to match(/Tel/)
    expect(rendered).to match(/Website/)
    expect(rendered).to match(/1/)
  end
end
