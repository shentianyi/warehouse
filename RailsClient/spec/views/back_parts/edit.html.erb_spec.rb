require 'rails_helper'

RSpec.describe "back_parts/edit", type: :view do
  before(:each) do
    @back_part = assign(:back_part, BackPart.create!(
      :builder => "MyString",
      :des_location_id => "MyString",
      :src_location_id => "MyString"
    ))
  end

  it "renders the edit back_part form" do
    render

    assert_select "form[action=?][method=?]", back_part_path(@back_part), "post" do

      assert_select "input#back_part_builder[name=?]", "back_part[builder]"

      assert_select "input#back_part_des_location_id[name=?]", "back_part[des_location_id]"

      assert_select "input#back_part_src_location_id[name=?]", "back_part[src_location_id]"
    end
  end
end
