require 'rails_helper'

RSpec.describe "part_types/edit", :type => :view do
  before(:each) do
    @part_type = assign(:part_type, PartType.create!(
      :name => "MyString"
    ))
  end

  it "renders the edit part_type form" do
    render

    assert_select "form[action=?][method=?]", part_type_path(@part_type), "post" do

      assert_select "input#part_type_name[name=?]", "part_type[name]"
    end
  end
end
