require 'rails_helper'

RSpec.describe "modems/edit", :type => :view do
  before(:each) do
    @modem = assign(:modem, Modem.create!(
      :id => "MyString",
      :name => "MyString",
      :ip => "MyString"
    ))
  end

  it "renders the edit modem form" do
    render

    assert_select "form[action=?][method=?]", modem_path(@modem), "post" do

      assert_select "input#modem_id[name=?]", "modem[id]"

      assert_select "input#modem_name[name=?]", "modem[name]"

      assert_select "input#modem_ip[name=?]", "modem[ip]"
    end
  end
end
