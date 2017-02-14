require 'rails_helper'

RSpec.describe "order_box_types/show", type: :view do
  before(:each) do
    @order_box_type = assign(:order_box_type, OrderBoxType.create!(
      :name => "Name",
      :description => "Description",
      :weight => 1.5
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Description/)
    expect(rendered).to match(/1.5/)
  end
end
