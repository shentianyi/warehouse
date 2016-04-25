require 'rails_helper'

RSpec.describe "movement_lists/new", type: :view do
  before(:each) do
    assign(:movement_list, MovementList.new(
      :name => "MyString",
      :state => 1,
      :builder => "MyString",
      :remarks => "MyString"
    ))
  end

  it "renders new movement_list form" do
    render

    assert_select "form[action=?][method=?]", movement_lists_path, "post" do

      assert_select "input#movement_list_name[name=?]", "movement_list[name]"

      assert_select "input#movement_list_state[name=?]", "movement_list[state]"

      assert_select "input#movement_list_builder[name=?]", "movement_list[builder]"

      assert_select "input#movement_list_remarks[name=?]", "movement_list[remarks]"
    end
  end
end
