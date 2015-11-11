require 'rails_helper'

RSpec.describe "movement_lists/new", type: :view do
  before(:each) do
    assign(:movement_list, MovementList.new(
      :builder => "MyString"
    ))
  end

  it "renders new movement_list form" do
    render

    assert_select "form[action=?][method=?]", movement_lists_path, "post" do

      assert_select "input#movement_list_builder[name=?]", "movement_list[builder]"
    end
  end
end
