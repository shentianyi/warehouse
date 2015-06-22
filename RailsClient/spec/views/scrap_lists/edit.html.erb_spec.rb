require 'rails_helper'

RSpec.describe "scrap_lists/edit", type: :view do
  before(:each) do
    @scrap_list = assign(:scrap_list, ScrapList.create!(
      :src_warehouse => "MyString",
      :dse_warehouse => "MyString",
      :builder => "MyString"
    ))
  end

  it "renders the edit scrap_list form" do
    render

    assert_select "form[action=?][method=?]", scrap_list_path(@scrap_list), "post" do

      assert_select "input#scrap_list_src_warehouse[name=?]", "scrap_list[src_warehouse]"

      assert_select "input#scrap_list_dse_warehouse[name=?]", "scrap_list[dse_warehouse]"

      assert_select "input#scrap_list_builder[name=?]", "scrap_list[builder]"
    end
  end
end
