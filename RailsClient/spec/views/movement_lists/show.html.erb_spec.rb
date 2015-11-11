require 'rails_helper'

RSpec.describe "movement_lists/show", type: :view do
  before(:each) do
    @movement_list = assign(:movement_list, MovementList.create!(
      :builder => "Builder"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Builder/)
  end
end
