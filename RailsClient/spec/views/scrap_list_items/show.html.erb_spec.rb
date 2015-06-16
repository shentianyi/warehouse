require 'rails_helper'

RSpec.describe "scrap_list_items/show", type: :view do
  before(:each) do
    @scrap_list_item = assign(:scrap_list_item, ScrapListItem.create!(
      :scrap_list_id => 1,
      :part_id => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
  end
end
