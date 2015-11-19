require 'rails_helper'

RSpec.describe "operation_logs/edit", type: :view do
  before(:each) do
    @operation_log = assign(:operation_log, OperationLog.create!(
      :item_type => "MyString",
      :item_id => "MyString",
      :event => "MyString",
      :whodunnit => "MyString",
      :object => "MyString"
    ))
  end

  it "renders the edit operation_log form" do
    render

    assert_select "form[action=?][method=?]", operation_log_path(@operation_log), "post" do

      assert_select "input#operation_log_item_type[name=?]", "operation_log[item_type]"

      assert_select "input#operation_log_item_id[name=?]", "operation_log[item_id]"

      assert_select "input#operation_log_event[name=?]", "operation_log[event]"

      assert_select "input#operation_log_whodunnit[name=?]", "operation_log[whodunnit]"

      assert_select "input#operation_log_object[name=?]", "operation_log[object]"
    end
  end
end
