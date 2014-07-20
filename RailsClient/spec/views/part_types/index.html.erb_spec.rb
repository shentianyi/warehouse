require 'rails_helper'

RSpec.describe "part_types/index", :type => :view do
  before(:each) do
    assign(:part_types, [
      PartType.create!(
        :name => "Name"
      ),
      PartType.create!(
        :name => "Name"
      )
    ])
  end

  it "renders a list of part_types" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
