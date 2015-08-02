require 'rails_helper'

RSpec.describe "inventory_lists/show", type: :view do
  before(:each) do
    @inventory_list = assign(:inventory_list, InventoryList.create!(
      :name => "Name",
      :state => 1,
      :whouse_id => "Whouse",
      :user_id => "User"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Whouse/)
    expect(rendered).to match(/User/)
  end
end
