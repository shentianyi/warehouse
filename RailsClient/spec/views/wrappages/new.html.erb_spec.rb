require 'rails_helper'

RSpec.describe "wrappages/new", type: :view do
  before(:each) do
    assign(:wrappage, Wrappage.new(
      :nr => "MyString",
      :name => "MyString",
      :desc => "MyString"
    ))
  end

  it "renders new wrappage form" do
    render

    assert_select "form[action=?][method=?]", wrappages_path, "post" do

      assert_select "input#wrappage_nr[name=?]", "wrappage[nr]"

      assert_select "input#wrappage_name[name=?]", "wrappage[name]"

      assert_select "input#wrappage_desc[name=?]", "wrappage[desc]"
    end
  end
end
