require 'rails_helper'

RSpec.describe "tenants/index", type: :view do
  before(:each) do
    assign(:tenants, [
      Tenant.create!(
        :name => "Name",
        :code => "Code",
        :address => "Address",
        :email => "Email",
        :tel => "Tel",
        :website => "Website",
        :type => 1
      ),
      Tenant.create!(
        :name => "Name",
        :code => "Code",
        :address => "Address",
        :email => "Email",
        :tel => "Tel",
        :website => "Website",
        :type => 1
      )
    ])
  end

  it "renders a list of tenants" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Code".to_s, :count => 2
    assert_select "tr>td", :text => "Address".to_s, :count => 2
    assert_select "tr>td", :text => "Email".to_s, :count => 2
    assert_select "tr>td", :text => "Tel".to_s, :count => 2
    assert_select "tr>td", :text => "Website".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
