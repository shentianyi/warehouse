require 'rails_helper'

RSpec.describe "storage_operation_records/show", type: :view do
  before(:each) do
    @storage_operation_record = assign(:storage_operation_record, StorageOperationRecord.create!(
      :partNr => "Part Nr",
      :qty => "Qty",
      :fromWh => "From Wh",
      :fromPosition => "From Position",
      :toWh => "To Wh",
      :toPosition => "To Position",
      :packageId => "Package",
      :type_id => "Type",
      :remarks => "Remarks",
      :employee_id => "Employee"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Part Nr/)
    expect(rendered).to match(/Qty/)
    expect(rendered).to match(/From Wh/)
    expect(rendered).to match(/From Position/)
    expect(rendered).to match(/To Wh/)
    expect(rendered).to match(/To Position/)
    expect(rendered).to match(/Package/)
    expect(rendered).to match(/Type/)
    expect(rendered).to match(/Remarks/)
    expect(rendered).to match(/Employee/)
  end
end
