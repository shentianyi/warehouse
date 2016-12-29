require "rails_helper"

RSpec.describe DockPointsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/dock_points").to route_to("dock_points#index")
    end

    it "routes to #new" do
      expect(:get => "/dock_points/new").to route_to("dock_points#new")
    end

    it "routes to #show" do
      expect(:get => "/dock_points/1").to route_to("dock_points#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/dock_points/1/edit").to route_to("dock_points#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/dock_points").to route_to("dock_points#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/dock_points/1").to route_to("dock_points#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/dock_points/1").to route_to("dock_points#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/dock_points/1").to route_to("dock_points#destroy", :id => "1")
    end

  end
end
