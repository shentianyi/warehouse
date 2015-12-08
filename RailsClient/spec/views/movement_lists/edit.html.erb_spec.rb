require 'rails_helper'

RSpec.describe "movement_lists/edit", type: :view do
  before(:each) do
    @movement_list = assign(:movement_list, MovementList.create!(
      :builder => "MyString"
    ))
  end

  it "renders the edit movement_list form" do
    render

    assert_select "form[action=?][method=?]", movement_list_path(@movement_list), "post" do

      assert_select "input#movement_list_builder[name=?]", "movement_list[builder]"
    end
  end
end
