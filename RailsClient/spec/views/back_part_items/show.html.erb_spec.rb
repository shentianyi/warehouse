require 'rails_helper'

RSpec.describe "back_part_items/show", type: :view do
  before(:each) do
    @back_part_item = assign(:back_part_item, BackPartItem.create!(
      :back_part => nil,
      :part => nil,
      :qty => 1.5,
      :back_reason => "Back Reason",
      :has_sample => "Has Sample",
      :remark => "Remark",
      :whouse => nil,
      :position => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/1.5/)
    expect(rendered).to match(/Back Reason/)
    expect(rendered).to match(/Has Sample/)
    expect(rendered).to match(/Remark/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
