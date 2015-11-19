require 'rails_helper'

RSpec.describe "operation_logs/show", type: :view do
  before(:each) do
    @operation_log = assign(:operation_log, OperationLog.create!(
      :item_type => "Item Type",
      :item_id => "Item",
      :event => "Event",
      :whodunnit => "Whodunnit",
      :object => "Object"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Item Type/)
    expect(rendered).to match(/Item/)
    expect(rendered).to match(/Event/)
    expect(rendered).to match(/Whodunnit/)
    expect(rendered).to match(/Object/)
  end
end
