require 'rails_helper'

RSpec.describe "part_types/new", :type => :view do
  before(:each) do
    assign(:part_type, PartType.new(
      :name => "MyString"
    ))
  end

  it "renders new part_type form" do
    render

    assert_select "form[action=?][method=?]", part_types_path, "post" do

      assert_select "input#part_type_name[name=?]", "part_type[name]"
    end
  end
end
