require 'rails_helper'

RSpec.describe "movement_lists/show", type: :view do
  before(:each) do
    @movement_list = assign(:movement_list, MovementList.create!(
      :name => "Name",
      :state => 1,
      :builder => "Builder",
      :remarks => "Remarks"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Builder/)
    expect(rendered).to match(/Remarks/)
  end
end
