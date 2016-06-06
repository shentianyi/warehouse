require 'rails_helper'

RSpec.describe "wrappage_movements/edit", type: :view do
  before(:each) do
    @wrappage_movement = assign(:wrappage_movement, WrappageMovement.create!(
      :move_date => "MyString",
      :package_type => nil,
      :user => nil
    ))
  end

  it "renders the edit wrappage_movement form" do
    render

    assert_select "form[action=?][method=?]", wrappage_movement_path(@wrappage_movement), "post" do

      assert_select "input#wrappage_movement_move_date[name=?]", "wrappage_movement[move_date]"

      assert_select "input#wrappage_movement_package_type_id[name=?]", "wrappage_movement[package_type_id]"

      assert_select "input#wrappage_movement_user_id[name=?]", "wrappage_movement[user_id]"
    end
  end
end
