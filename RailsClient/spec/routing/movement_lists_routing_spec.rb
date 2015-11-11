require "rails_helper"

RSpec.describe MovementListsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/movement_lists").to route_to("movement_lists#index")
    end

    it "routes to #new" do
      expect(:get => "/movement_lists/new").to route_to("movement_lists#new")
    end

    it "routes to #show" do
      expect(:get => "/movement_lists/1").to route_to("movement_lists#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/movement_lists/1/edit").to route_to("movement_lists#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/movement_lists").to route_to("movement_lists#create")
    end

    it "routes to #update" do
      expect(:put => "/movement_lists/1").to route_to("movement_lists#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/movement_lists/1").to route_to("movement_lists#destroy", :id => "1")
    end

  end
end
