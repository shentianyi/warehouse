require 'rails_helper'

RSpec.describe "ptl_jobs/show", type: :view do
  before(:each) do
    @ptl_job = assign(:ptl_job, PtlJob.create!(
      :params => "MyText",
      :state => 1,
      :is_dirty => false,
      :is_new => false,
      :is_delete => false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
  end
end
