require 'rails_helper'

RSpec.describe "back_part_items/index", type: :view do
  before(:each) do
    assign(:back_part_items, [
      BackPartItem.create!(
        :back_part => nil,
        :part => nil,
        :qty => 1.5,
        :back_reason => "Back Reason",
        :has_sample => "Has Sample",
        :remark => "Remark",
        :whouse => nil,
        :position => nil
      ),
      BackPartItem.create!(
        :back_part => nil,
        :part => nil,
        :qty => 1.5,
        :back_reason => "Back Reason",
        :has_sample => "Has Sample",
        :remark => "Remark",
        :whouse => nil,
        :position => nil
      )
    ])
  end

  it "renders a list of back_part_items" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => "Back Reason".to_s, :count => 2
    assert_select "tr>td", :text => "Has Sample".to_s, :count => 2
    assert_select "tr>td", :text => "Remark".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
