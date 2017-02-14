require "rails_helper"

RSpec.describe OrderBoxTypesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/order_box_types").to route_to("order_box_types#index")
    end

    it "routes to #new" do
      expect(:get => "/order_box_types/new").to route_to("order_box_types#new")
    end

    it "routes to #show" do
      expect(:get => "/order_box_types/1").to route_to("order_box_types#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/order_box_types/1/edit").to route_to("order_box_types#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/order_box_types").to route_to("order_box_types#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/order_box_types/1").to route_to("order_box_types#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/order_box_types/1").to route_to("order_box_types#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/order_box_types/1").to route_to("order_box_types#destroy", :id => "1")
    end

  end
end
