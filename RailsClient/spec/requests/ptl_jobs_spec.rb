require 'rails_helper'

RSpec.describe "PtlJobs", type: :request do
  describe "GET /ptl_jobs" do
    it "works! (now write some real specs)" do
      get ptl_jobs_path
      expect(response).to have_http_status(200)
    end
  end
end
