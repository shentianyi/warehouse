require 'rails_helper'

RSpec.describe "movement_lists/index", type: :view do
  before(:each) do
    assign(:movement_lists, [
      MovementList.create!(
        :name => "Name",
        :state => 1,
        :builder => "Builder",
        :remarks => "Remarks"
      ),
      MovementList.create!(
        :name => "Name",
        :state => 1,
        :builder => "Builder",
        :remarks => "Remarks"
      )
    ])
  end

  it "renders a list of movement_lists" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Builder".to_s, :count => 2
    assert_select "tr>td", :text => "Remarks".to_s, :count => 2
  end
end
