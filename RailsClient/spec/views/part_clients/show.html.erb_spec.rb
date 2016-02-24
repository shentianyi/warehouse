require 'rails_helper'

RSpec.describe "part_clients/show", type: :view do
  before(:each) do
    @part_client = assign(:part_client, PartClient.create!(
      :parts => nil,
      :client_part_nr => "Client Part Nr",
      :client_tenant_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/Client Part Nr/)
    expect(rendered).to match(/1/)
  end
end
