require 'rails_helper'

RSpec.describe "pick_item_filters/show", :type => :view do
  before(:each) do
    @pick_item_filter = assign(:pick_item_filter, PickItemFilter.create!(
      :id => "Id",
      :user_id => "User",
      :value => "Value",
      :filterable_id => "Filterable",
      :filterable_type => "Filterable Type"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Id/)
    expect(rendered).to match(/User/)
    expect(rendered).to match(/Value/)
    expect(rendered).to match(/Filterable/)
    expect(rendered).to match(/Filterable Type/)
  end
end
