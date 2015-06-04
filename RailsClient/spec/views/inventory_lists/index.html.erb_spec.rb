require 'rails_helper'

RSpec.describe "inventory_lists/index", type: :view do
  before(:each) do
    assign(:inventory_lists, [
      InventoryList.create!(
        :name => "Name",
        :state => 1,
        :whouse_id => "Whouse",
        :user_id => "User"
      ),
      InventoryList.create!(
        :name => "Name",
        :state => 1,
        :whouse_id => "Whouse",
        :user_id => "User"
      )
    ])
  end

  it "renders a list of inventory_lists" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Whouse".to_s, :count => 2
    assert_select "tr>td", :text => "User".to_s, :count => 2
  end
end
