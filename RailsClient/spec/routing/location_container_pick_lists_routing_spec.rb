require "rails_helper"

RSpec.describe LocationContainerPickListsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/location_container_pick_lists").to route_to("location_container_pick_lists#index")
    end

    it "routes to #new" do
      expect(:get => "/location_container_pick_lists/new").to route_to("location_container_pick_lists#new")
    end

    it "routes to #show" do
      expect(:get => "/location_container_pick_lists/1").to route_to("location_container_pick_lists#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/location_container_pick_lists/1/edit").to route_to("location_container_pick_lists#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/location_container_pick_lists").to route_to("location_container_pick_lists#create")
    end

    it "routes to #update" do
      expect(:put => "/location_container_pick_lists/1").to route_to("location_container_pick_lists#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/location_container_pick_lists/1").to route_to("location_container_pick_lists#destroy", :id => "1")
    end

  end
end
