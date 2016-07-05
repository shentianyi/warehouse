require 'rails_helper'

RSpec.describe "part_wrappages/edit", type: :view do
  before(:each) do
    @part_wrappage = assign(:part_wrappage, PartWrappage.create!(
      :part_id => "MyString",
      :wrappage_id => 1,
      :capacity => 1
    ))
  end

  it "renders the edit part_wrappage form" do
    render

    assert_select "form[action=?][method=?]", part_wrappage_path(@part_wrappage), "post" do

      assert_select "input#part_wrappage_part_id[name=?]", "part_wrappage[part_id]"

      assert_select "input#part_wrappage_wrappage_id[name=?]", "part_wrappage[wrappage_id]"

      assert_select "input#part_wrappage_capacity[name=?]", "part_wrappage[capacity]"
    end
  end
end
