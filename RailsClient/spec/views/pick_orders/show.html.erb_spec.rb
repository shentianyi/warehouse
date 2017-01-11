require 'rails_helper'

RSpec.describe "pick_orders/show", type: :view do
  before(:each) do
    @pick_order = assign(:pick_order, PickOrder.create!(
      :order => nil,
      :pick_list => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
