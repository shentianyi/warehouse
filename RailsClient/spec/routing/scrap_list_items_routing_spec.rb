require "rails_helper"

RSpec.describe ScrapListItemsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/scrap_list_items").to route_to("scrap_list_items#index")
    end

    it "routes to #new" do
      expect(:get => "/scrap_list_items/new").to route_to("scrap_list_items#new")
    end

    it "routes to #show" do
      expect(:get => "/scrap_list_items/1").to route_to("scrap_list_items#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/scrap_list_items/1/edit").to route_to("scrap_list_items#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/scrap_list_items").to route_to("scrap_list_items#create")
    end

    it "routes to #update" do
      expect(:put => "/scrap_list_items/1").to route_to("scrap_list_items#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/scrap_list_items/1").to route_to("scrap_list_items#destroy", :id => "1")
    end

  end
end
