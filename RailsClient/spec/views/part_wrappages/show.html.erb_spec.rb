require 'rails_helper'

RSpec.describe "part_wrappages/show", type: :view do
  before(:each) do
    @part_wrappage = assign(:part_wrappage, PartWrappage.create!(
      :part_id => "Part",
      :wrappage_id => 1,
      :capacity => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Part/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
  end
end
