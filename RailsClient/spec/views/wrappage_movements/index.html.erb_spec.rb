require 'rails_helper'

RSpec.describe "wrappage_movements/index", type: :view do
  before(:each) do
    assign(:wrappage_movements, [
      WrappageMovement.create!(
        :move_date => "Move Date",
        :package_type => nil,
        :user => nil
      ),
      WrappageMovement.create!(
        :move_date => "Move Date",
        :package_type => nil,
        :user => nil
      )
    ])
  end

  it "renders a list of wrappage_movements" do
    render
    assert_select "tr>td", :text => "Move Date".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
