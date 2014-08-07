require 'rails_helper'

RSpec.describe "pick_lists/show", :type => :view do
  before(:each) do
    @pick_list = assign(:pick_list, PickList.create!(
      :id => "Id",
      :user_id => "User"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Id/)
    expect(rendered).to match(/User/)
  end
end
