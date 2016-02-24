require 'rails_helper'

RSpec.describe "part_clients/index", type: :view do
  before(:each) do
    assign(:part_clients, [
      PartClient.create!(
        :parts => nil,
        :client_part_nr => "Client Part Nr",
        :client_tenant_id => 1
      ),
      PartClient.create!(
        :parts => nil,
        :client_part_nr => "Client Part Nr",
        :client_tenant_id => 1
      )
    ])
  end

  it "renders a list of part_clients" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Client Part Nr".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
