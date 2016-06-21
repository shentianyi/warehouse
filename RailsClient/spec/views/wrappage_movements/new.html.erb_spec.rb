require 'rails_helper'

RSpec.describe "wrappage_movements/new", type: :view do
  before(:each) do
    assign(:wrappage_movement, WrappageMovement.new(
      :move_date => "MyString",
      :package_type => nil,
      :user => nil
    ))
  end

  it "renders new wrappage_movement form" do
    render

    assert_select "form[action=?][method=?]", wrappage_movements_path, "post" do

      assert_select "input#wrappage_movement_move_date[name=?]", "wrappage_movement[move_date]"

      assert_select "input#wrappage_movement_package_type_id[name=?]", "wrappage_movement[package_type_id]"

      assert_select "input#wrappage_movement_user_id[name=?]", "wrappage_movement[user_id]"
    end
  end
end
