require 'rails_helper'

RSpec.describe "wrappages/index", type: :view do
  before(:each) do
    assign(:wrappages, [
      Wrappage.create!(
        :nr => "Nr",
        :name => "Name",
        :desc => "Desc"
      ),
      Wrappage.create!(
        :nr => "Nr",
        :name => "Name",
        :desc => "Desc"
      )
    ])
  end

  it "renders a list of wrappages" do
    render
    assert_select "tr>td", :text => "Nr".to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Desc".to_s, :count => 2
  end
end
