require 'rails_helper'

RSpec.describe "operation_logs/index", type: :view do
  before(:each) do
    assign(:operation_logs, [
      OperationLog.create!(
        :item_type => "Item Type",
        :item_id => "Item",
        :event => "Event",
        :whodunnit => "Whodunnit",
        :object => "Object"
      ),
      OperationLog.create!(
        :item_type => "Item Type",
        :item_id => "Item",
        :event => "Event",
        :whodunnit => "Whodunnit",
        :object => "Object"
      )
    ])
  end

  it "renders a list of operation_logs" do
    render
    assert_select "tr>td", :text => "Item Type".to_s, :count => 2
    assert_select "tr>td", :text => "Item".to_s, :count => 2
    assert_select "tr>td", :text => "Event".to_s, :count => 2
    assert_select "tr>td", :text => "Whodunnit".to_s, :count => 2
    assert_select "tr>td", :text => "Object".to_s, :count => 2
  end
end
