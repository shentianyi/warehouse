require 'rails_helper'

RSpec.describe "movement_lists/index", type: :view do
  before(:each) do
    assign(:movement_lists, [
      MovementList.create!(
        :builder => "Builder"
      ),
      MovementList.create!(
        :builder => "Builder"
      )
    ])
  end

  it "renders a list of movement_lists" do
    render
    assert_select "tr>td", :text => "Builder".to_s, :count => 2
  end
end
