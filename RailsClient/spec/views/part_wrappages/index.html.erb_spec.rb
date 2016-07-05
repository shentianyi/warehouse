require 'rails_helper'

RSpec.describe "part_wrappages/index", type: :view do
  before(:each) do
    assign(:part_wrappages, [
      PartWrappage.create!(
        :part_id => "Part",
        :wrappage_id => 1,
        :capacity => 2
      ),
      PartWrappage.create!(
        :part_id => "Part",
        :wrappage_id => 1,
        :capacity => 2
      )
    ])
  end

  it "renders a list of part_wrappages" do
    render
    assert_select "tr>td", :text => "Part".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
