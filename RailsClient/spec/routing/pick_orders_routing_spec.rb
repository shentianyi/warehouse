require "rails_helper"

RSpec.describe PickOrdersController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/pick_orders").to route_to("pick_orders#index")
    end

    it "routes to #new" do
      expect(:get => "/pick_orders/new").to route_to("pick_orders#new")
    end

    it "routes to #show" do
      expect(:get => "/pick_orders/1").to route_to("pick_orders#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/pick_orders/1/edit").to route_to("pick_orders#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/pick_orders").to route_to("pick_orders#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/pick_orders/1").to route_to("pick_orders#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/pick_orders/1").to route_to("pick_orders#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/pick_orders/1").to route_to("pick_orders#destroy", :id => "1")
    end

  end
end
