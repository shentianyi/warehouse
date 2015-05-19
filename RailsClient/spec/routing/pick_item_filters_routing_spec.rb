require "rails_helper"

RSpec.describe PickItemFiltersController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/pick_item_filters").to route_to("pick_item_filters#index")
    end

    it "routes to #new" do
      expect(:get => "/pick_item_filters/new").to route_to("pick_item_filters#new")
    end

    it "routes to #show" do
      expect(:get => "/pick_item_filters/1").to route_to("pick_item_filters#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/pick_item_filters/1/edit").to route_to("pick_item_filters#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/pick_item_filters").to route_to("pick_item_filters#create")
    end

    it "routes to #update" do
      expect(:put => "/pick_item_filters/1").to route_to("pick_item_filters#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/pick_item_filters/1").to route_to("pick_item_filters#destroy", :id => "1")
    end

  end
end
