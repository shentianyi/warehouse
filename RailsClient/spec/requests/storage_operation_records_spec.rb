require 'rails_helper'

RSpec.describe "StorageOperationRecords", type: :request do
  describe "GET /storage_operation_records" do
    it "works! (now write some real specs)" do
      get storage_operation_records_path
      expect(response).to have_http_status(200)
    end
  end
end
