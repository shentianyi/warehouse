require 'rails_helper'

RSpec.describe "scrap_lists/show", type: :view do
  before(:each) do
    @scrap_list = assign(:scrap_list, ScrapList.create!(
      :src_warehouse => "Src Warehouse",
      :dse_warehouse => "Dse Warehouse",
      :builder => "Builder"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Src Warehouse/)
    expect(rendered).to match(/Dse Warehouse/)
    expect(rendered).to match(/Builder/)
  end
end
