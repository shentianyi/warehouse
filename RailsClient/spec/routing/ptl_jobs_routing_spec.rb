require "rails_helper"

RSpec.describe PtlJobsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/ptl_jobs").to route_to("ptl_jobs#index")
    end

    it "routes to #new" do
      expect(:get => "/ptl_jobs/new").to route_to("ptl_jobs#new")
    end

    it "routes to #show" do
      expect(:get => "/ptl_jobs/1").to route_to("ptl_jobs#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/ptl_jobs/1/edit").to route_to("ptl_jobs#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/ptl_jobs").to route_to("ptl_jobs#create")
    end

    it "routes to #update" do
      expect(:put => "/ptl_jobs/1").to route_to("ptl_jobs#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/ptl_jobs/1").to route_to("ptl_jobs#destroy", :id => "1")
    end

  end
end
