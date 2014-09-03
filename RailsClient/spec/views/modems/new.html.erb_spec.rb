require 'rails_helper'

RSpec.describe "modems/new", :type => :view do
  before(:each) do
    assign(:modem, Modem.new(
      :id => "MyString",
      :name => "MyString",
      :ip => "MyString"
    ))
  end

  it "renders new modem form" do
    render

    assert_select "form[action=?][method=?]", modems_path, "post" do

      assert_select "input#modem_id[name=?]", "modem[id]"

      assert_select "input#modem_name[name=?]", "modem[name]"

      assert_select "input#modem_ip[name=?]", "modem[ip]"
    end
  end
end
