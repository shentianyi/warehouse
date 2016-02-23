require 'rails_helper'

RSpec.describe "tenants/edit", type: :view do
  before(:each) do
    @tenant = assign(:tenant, Tenant.create!(
      :name => "MyString",
      :code => "MyString",
      :address => "MyString",
      :email => "MyString",
      :tel => "MyString",
      :website => "MyString",
      :type => 1
    ))
  end

  it "renders the edit tenant form" do
    render

    assert_select "form[action=?][method=?]", tenant_path(@tenant), "post" do

      assert_select "input#tenant_name[name=?]", "tenant[name]"

      assert_select "input#tenant_code[name=?]", "tenant[code]"

      assert_select "input#tenant_address[name=?]", "tenant[address]"

      assert_select "input#tenant_email[name=?]", "tenant[email]"

      assert_select "input#tenant_tel[name=?]", "tenant[tel]"

      assert_select "input#tenant_website[name=?]", "tenant[website]"

      assert_select "input#tenant_type[name=?]", "tenant[type]"
    end
  end
end
