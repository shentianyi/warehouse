require "rails_helper"

RSpec.describe InventoryListsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/inventory_lists").to route_to("inventory_lists#index")
    end

    it "routes to #new" do
      expect(:get => "/inventory_lists/new").to route_to("inventory_lists#new")
    end

    it "routes to #show" do
      expect(:get => "/inventory_lists/1").to route_to("inventory_lists#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/inventory_lists/1/edit").to route_to("inventory_lists#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/inventory_lists").to route_to("inventory_lists#create")
    end

    it "routes to #update" do
      expect(:put => "/inventory_lists/1").to route_to("inventory_lists#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/inventory_lists/1").to route_to("inventory_lists#destroy", :id => "1")
    end

  end
end
