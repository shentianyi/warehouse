require 'rails_helper'

RSpec.describe "order_boxes/show", type: :view do
  before(:each) do
    @order_box = assign(:order_box, OrderBox.create!(
      :nr => "Nr",
      :rfid => "Rfid",
      :status => 1,
      :part => nil,
      :quantity => 1.5,
      :order_box_type => nil,
      :warehouse => nil,
      :source_warehouse => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Nr/)
    expect(rendered).to match(/Rfid/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(//)
    expect(rendered).to match(/1.5/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
