require 'rails_helper'

RSpec.describe "part_clients/edit", type: :view do
  before(:each) do
    @part_client = assign(:part_client, PartClient.create!(
      :parts => nil,
      :client_part_nr => "MyString",
      :client_tenant_id => 1
    ))
  end

  it "renders the edit part_client form" do
    render

    assert_select "form[action=?][method=?]", part_client_path(@part_client), "post" do

      assert_select "input#part_client_parts_id[name=?]", "part_client[parts_id]"

      assert_select "input#part_client_client_part_nr[name=?]", "part_client[client_part_nr]"

      assert_select "input#part_client_client_tenant_id[name=?]", "part_client[client_tenant_id]"
    end
  end
end
