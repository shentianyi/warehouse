require "rails_helper"

RSpec.describe StorageOperationRecordsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/storage_operation_records").to route_to("storage_operation_records#index")
    end

    it "routes to #new" do
      expect(:get => "/storage_operation_records/new").to route_to("storage_operation_records#new")
    end

    it "routes to #show" do
      expect(:get => "/storage_operation_records/1").to route_to("storage_operation_records#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/storage_operation_records/1/edit").to route_to("storage_operation_records#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/storage_operation_records").to route_to("storage_operation_records#create")
    end

    it "routes to #update" do
      expect(:put => "/storage_operation_records/1").to route_to("storage_operation_records#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/storage_operation_records/1").to route_to("storage_operation_records#destroy", :id => "1")
    end

  end
end
