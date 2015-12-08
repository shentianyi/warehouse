require 'rails_helper'

RSpec.describe "storage_operation_records/edit", type: :view do
  before(:each) do
    @storage_operation_record = assign(:storage_operation_record, StorageOperationRecord.create!(
      :partNr => "MyString",
      :qty => "MyString",
      :fromWh => "MyString",
      :fromPosition => "MyString",
      :toWh => "MyString",
      :toPosition => "MyString",
      :packageId => "MyString",
      :type_id => "MyString",
      :remarks => "MyString",
      :employee_id => "MyString"
    ))
  end

  it "renders the edit storage_operation_record form" do
    render

    assert_select "form[action=?][method=?]", storage_operation_record_path(@storage_operation_record), "post" do

      assert_select "input#storage_operation_record_partNr[name=?]", "storage_operation_record[partNr]"

      assert_select "input#storage_operation_record_qty[name=?]", "storage_operation_record[qty]"

      assert_select "input#storage_operation_record_fromWh[name=?]", "storage_operation_record[fromWh]"

      assert_select "input#storage_operation_record_fromPosition[name=?]", "storage_operation_record[fromPosition]"

      assert_select "input#storage_operation_record_toWh[name=?]", "storage_operation_record[toWh]"

      assert_select "input#storage_operation_record_toPosition[name=?]", "storage_operation_record[toPosition]"

      assert_select "input#storage_operation_record_packageId[name=?]", "storage_operation_record[packageId]"

      assert_select "input#storage_operation_record_type_id[name=?]", "storage_operation_record[type_id]"

      assert_select "input#storage_operation_record_remarks[name=?]", "storage_operation_record[remarks]"

      assert_select "input#storage_operation_record_employee_id[name=?]", "storage_operation_record[employee_id]"
    end
  end
end
