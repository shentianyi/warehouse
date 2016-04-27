require "rails_helper"

RSpec.describe BackPartItemsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/back_part_items").to route_to("back_part_items#index")
    end

    it "routes to #new" do
      expect(:get => "/back_part_items/new").to route_to("back_part_items#new")
    end

    it "routes to #show" do
      expect(:get => "/back_part_items/1").to route_to("back_part_items#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/back_part_items/1/edit").to route_to("back_part_items#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/back_part_items").to route_to("back_part_items#create")
    end

    it "routes to #update" do
      expect(:put => "/back_part_items/1").to route_to("back_part_items#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/back_part_items/1").to route_to("back_part_items#destroy", :id => "1")
    end

  end
end
