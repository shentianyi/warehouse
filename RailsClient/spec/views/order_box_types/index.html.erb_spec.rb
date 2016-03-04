require 'rails_helper'

RSpec.describe "order_box_types/index", type: :view do
  before(:each) do
    assign(:order_box_types, [
      OrderBoxType.create!(
        :name => "Name",
        :description => "Description",
        :weight => 1.5
      ),
      OrderBoxType.create!(
        :name => "Name",
        :description => "Description",
        :weight => 1.5
      )
    ])
  end

  it "renders a list of order_box_types" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
  end
end
