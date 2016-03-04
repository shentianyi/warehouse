require "rails_helper"

RSpec.describe OrderCarsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/order_cars").to route_to("order_cars#index")
    end

    it "routes to #new" do
      expect(:get => "/order_cars/new").to route_to("order_cars#new")
    end

    it "routes to #show" do
      expect(:get => "/order_cars/1").to route_to("order_cars#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/order_cars/1/edit").to route_to("order_cars#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/order_cars").to route_to("order_cars#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/order_cars/1").to route_to("order_cars#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/order_cars/1").to route_to("order_cars#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/order_cars/1").to route_to("order_cars#destroy", :id => "1")
    end

  end
end
