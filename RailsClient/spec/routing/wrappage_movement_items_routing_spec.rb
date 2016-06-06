require "rails_helper"

RSpec.describe WrappageMovementItemsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/wrappage_movement_items").to route_to("wrappage_movement_items#index")
    end

    it "routes to #new" do
      expect(:get => "/wrappage_movement_items/new").to route_to("wrappage_movement_items#new")
    end

    it "routes to #show" do
      expect(:get => "/wrappage_movement_items/1").to route_to("wrappage_movement_items#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/wrappage_movement_items/1/edit").to route_to("wrappage_movement_items#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/wrappage_movement_items").to route_to("wrappage_movement_items#create")
    end

    it "routes to #update" do
      expect(:put => "/wrappage_movement_items/1").to route_to("wrappage_movement_items#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/wrappage_movement_items/1").to route_to("wrappage_movement_items#destroy", :id => "1")
    end

  end
end
