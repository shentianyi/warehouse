require "rails_helper"

RSpec.describe LocationContainerOrdersController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/location_container_orders").to route_to("location_container_orders#index")
    end

    it "routes to #new" do
      expect(:get => "/location_container_orders/new").to route_to("location_container_orders#new")
    end

    it "routes to #show" do
      expect(:get => "/location_container_orders/1").to route_to("location_container_orders#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/location_container_orders/1/edit").to route_to("location_container_orders#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/location_container_orders").to route_to("location_container_orders#create")
    end

    it "routes to #update" do
      expect(:put => "/location_container_orders/1").to route_to("location_container_orders#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/location_container_orders/1").to route_to("location_container_orders#destroy", :id => "1")
    end

  end
end
