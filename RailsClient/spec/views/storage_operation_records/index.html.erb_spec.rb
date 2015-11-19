require 'rails_helper'

RSpec.describe "storage_operation_records/index", type: :view do
  before(:each) do
    assign(:storage_operation_records, [
      StorageOperationRecord.create!(
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
      ),
      StorageOperationRecord.create!(
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
      )
    ])
  end

  it "renders a list of storage_operation_records" do
    render
    assert_select "tr>td", :text => "Part Nr".to_s, :count => 2
    assert_select "tr>td", :text => "Qty".to_s, :count => 2
    assert_select "tr>td", :text => "From Wh".to_s, :count => 2
    assert_select "tr>td", :text => "From Position".to_s, :count => 2
    assert_select "tr>td", :text => "To Wh".to_s, :count => 2
    assert_select "tr>td", :text => "To Position".to_s, :count => 2
    assert_select "tr>td", :text => "Package".to_s, :count => 2
    assert_select "tr>td", :text => "Type".to_s, :count => 2
    assert_select "tr>td", :text => "Remarks".to_s, :count => 2
    assert_select "tr>td", :text => "Employee".to_s, :count => 2
  end
end
