require 'rails_helper'

RSpec.describe "scrap_lists/index", type: :view do
  before(:each) do
    assign(:scrap_lists, [
      ScrapList.create!(
        :src_warehouse => "Src Warehouse",
        :dse_warehouse => "Dse Warehouse",
        :builder => "Builder"
      ),
      ScrapList.create!(
        :src_warehouse => "Src Warehouse",
        :dse_warehouse => "Dse Warehouse",
        :builder => "Builder"
      )
    ])
  end

  it "renders a list of scrap_lists" do
    render
    assert_select "tr>td", :text => "Src Warehouse".to_s, :count => 2
    assert_select "tr>td", :text => "Dse Warehouse".to_s, :count => 2
    assert_select "tr>td", :text => "Builder".to_s, :count => 2
  end
end
