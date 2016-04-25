require 'rails_helper'

RSpec.describe "movement_sources/edit", type: :view do
  before(:each) do
    @movement_source = assign(:movement_source, MovementSource.create!(
      :movement_list => nil,
      :fromWh => "MyString",
      :fromPosition => "MyString",
      :packageId => "MyString",
      :partNr => "MyString",
      :qty => 1.5,
      :fifo => "MyString",
      :toWh => "MyString",
      :toPosition => "MyString",
      :employee_id => "MyString",
      :remarks => "MyString",
      :type => ""
    ))
  end

  it "renders the edit movement_source form" do
    render

    assert_select "form[action=?][method=?]", movement_source_path(@movement_source), "post" do

      assert_select "input#movement_source_movement_list_id[name=?]", "movement_source[movement_list_id]"

      assert_select "input#movement_source_fromWh[name=?]", "movement_source[fromWh]"

      assert_select "input#movement_source_fromPosition[name=?]", "movement_source[fromPosition]"

      assert_select "input#movement_source_packageId[name=?]", "movement_source[packageId]"

      assert_select "input#movement_source_partNr[name=?]", "movement_source[partNr]"

      assert_select "input#movement_source_qty[name=?]", "movement_source[qty]"

      assert_select "input#movement_source_fifo[name=?]", "movement_source[fifo]"

      assert_select "input#movement_source_toWh[name=?]", "movement_source[toWh]"

      assert_select "input#movement_source_toPosition[name=?]", "movement_source[toPosition]"

      assert_select "input#movement_source_employee_id[name=?]", "movement_source[employee_id]"

      assert_select "input#movement_source_remarks[name=?]", "movement_source[remarks]"

      assert_select "input#movement_source_type[name=?]", "movement_source[type]"
    end
  end
end
