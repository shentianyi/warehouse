require 'rails_helper'

RSpec.describe "pick_item_filters/index", :type => :view do
  before(:each) do
    assign(:pick_item_filters, [
      PickItemFilter.create!(
        :id => "Id",
        :user_id => "User",
        :value => "Value",
        :filterable_id => "Filterable",
        :filterable_type => "Filterable Type"
      ),
      PickItemFilter.create!(
        :id => "Id",
        :user_id => "User",
        :value => "Value",
        :filterable_id => "Filterable",
        :filterable_type => "Filterable Type"
      )
    ])
  end

  it "renders a list of pick_item_filters" do
    render
    assert_select "tr>td", :text => "Id".to_s, :count => 2
    assert_select "tr>td", :text => "User".to_s, :count => 2
    assert_select "tr>td", :text => "Value".to_s, :count => 2
    assert_select "tr>td", :text => "Filterable".to_s, :count => 2
    assert_select "tr>td", :text => "Filterable Type".to_s, :count => 2
  end
end
