require 'rails_helper'

RSpec.describe "operation_logs/new", type: :view do
  before(:each) do
    assign(:operation_log, OperationLog.new(
      :item_type => "MyString",
      :item_id => "MyString",
      :event => "MyString",
      :whodunnit => "MyString",
      :object => "MyString"
    ))
  end

  it "renders new operation_log form" do
    render

    assert_select "form[action=?][method=?]", operation_logs_path, "post" do

      assert_select "input#operation_log_item_type[name=?]", "operation_log[item_type]"

      assert_select "input#operation_log_item_id[name=?]", "operation_log[item_id]"

      assert_select "input#operation_log_event[name=?]", "operation_log[event]"

      assert_select "input#operation_log_whodunnit[name=?]", "operation_log[whodunnit]"

      assert_select "input#operation_log_object[name=?]", "operation_log[object]"
    end
  end
end
