require 'rails_helper'

RSpec.describe "ptl_jobs/edit", type: :view do
  before(:each) do
    @ptl_job = assign(:ptl_job, PtlJob.create!(
      :params => "MyText",
      :state => 1,
      :is_dirty => false,
      :is_new => false,
      :is_delete => false
    ))
  end

  it "renders the edit ptl_job form" do
    render

    assert_select "form[action=?][method=?]", ptl_job_path(@ptl_job), "post" do

      assert_select "textarea#ptl_job_params[name=?]", "ptl_job[params]"

      assert_select "input#ptl_job_state[name=?]", "ptl_job[state]"

      assert_select "input#ptl_job_is_dirty[name=?]", "ptl_job[is_dirty]"

      assert_select "input#ptl_job_is_new[name=?]", "ptl_job[is_new]"

      assert_select "input#ptl_job_is_delete[name=?]", "ptl_job[is_delete]"
    end
  end
end
