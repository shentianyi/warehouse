require 'rails_helper'

RSpec.describe "wrappages/edit", type: :view do
  before(:each) do
    @wrappage = assign(:wrappage, Wrappage.create!(
      :nr => "MyString",
      :name => "MyString",
      :desc => "MyString"
    ))
  end

  it "renders the edit wrappage form" do
    render

    assert_select "form[action=?][method=?]", wrappage_path(@wrappage), "post" do

      assert_select "input#wrappage_nr[name=?]", "wrappage[nr]"

      assert_select "input#wrappage_name[name=?]", "wrappage[name]"

      assert_select "input#wrappage_desc[name=?]", "wrappage[desc]"
    end
  end
end
