require 'rails_helper'

RSpec.describe "movement_sources/show", type: :view do
  before(:each) do
    @movement_source = assign(:movement_source, MovementSource.create!(
      :movement_list => nil,
      :fromWh => "From Wh",
      :fromPosition => "From Position",
      :packageId => "Package",
      :partNr => "Part Nr",
      :qty => 1.5,
      :fifo => "Fifo",
      :toWh => "To Wh",
      :toPosition => "To Position",
      :employee_id => "Employee",
      :remarks => "Remarks",
      :type => "Type"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/From Wh/)
    expect(rendered).to match(/From Position/)
    expect(rendered).to match(/Package/)
    expect(rendered).to match(/Part Nr/)
    expect(rendered).to match(/1.5/)
    expect(rendered).to match(/Fifo/)
    expect(rendered).to match(/To Wh/)
    expect(rendered).to match(/To Position/)
    expect(rendered).to match(/Employee/)
    expect(rendered).to match(/Remarks/)
    expect(rendered).to match(/Type/)
  end
end
