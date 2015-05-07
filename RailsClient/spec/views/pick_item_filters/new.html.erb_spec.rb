require 'rails_helper'

RSpec.describe "pick_item_filters/new", :type => :view do
  before(:each) do
    assign(:pick_item_filter, PickItemFilter.new(
      :id => "MyString",
      :user_id => "MyString",
      :value => "MyString",
      :filterable_id => "MyString",
      :filterable_type => "MyString"
    ))
  end

  it "renders new pick_item_filter form" do
    render

    assert_select "form[action=?][method=?]", pick_item_filters_path, "post" do

      assert_select "input#pick_item_filter_id[name=?]", "pick_item_filter[id]"

      assert_select "input#pick_item_filter_user_id[name=?]", "pick_item_filter[user_id]"

      assert_select "input#pick_item_filter_value[name=?]", "pick_item_filter[value]"

      assert_select "input#pick_item_filter_filterable_id[name=?]", "pick_item_filter[filterable_id]"

      assert_select "input#pick_item_filter_filterable_type[name=?]", "pick_item_filter[filterable_type]"
    end
  end
end
