require 'rails_helper'

RSpec.describe "ptl_jobs/index", type: :view do
  before(:each) do
    assign(:ptl_jobs, [
      PtlJob.create!(
        :params => "MyText",
        :state => 1,
        :is_dirty => false,
        :is_new => false,
        :is_delete => false
      ),
      PtlJob.create!(
        :params => "MyText",
        :state => 1,
        :is_dirty => false,
        :is_new => false,
        :is_delete => false
      )
    ])
  end

  it "renders a list of ptl_jobs" do
    render
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
