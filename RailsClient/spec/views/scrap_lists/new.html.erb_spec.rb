require 'rails_helper'

RSpec.describe "scrap_lists/new", type: :view do
  before(:each) do
    assign(:scrap_list, ScrapList.new(
      :src_warehouse => "MyString",
      :dse_warehouse => "MyString",
      :builder => "MyString"
    ))
  end

  it "renders new scrap_list form" do
    render

    assert_select "form[action=?][method=?]", scrap_lists_path, "post" do

      assert_select "input#scrap_list_src_warehouse[name=?]", "scrap_list[src_warehouse]"

      assert_select "input#scrap_list_dse_warehouse[name=?]", "scrap_list[dse_warehouse]"

      assert_select "input#scrap_list_builder[name=?]", "scrap_list[builder]"
    end
  end
end
