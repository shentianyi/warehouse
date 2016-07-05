require "rails_helper"

RSpec.describe WrappagesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/wrappages").to route_to("wrappages#index")
    end

    it "routes to #new" do
      expect(:get => "/wrappages/new").to route_to("wrappages#new")
    end

    it "routes to #show" do
      expect(:get => "/wrappages/1").to route_to("wrappages#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/wrappages/1/edit").to route_to("wrappages#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/wrappages").to route_to("wrappages#create")
    end

    it "routes to #update" do
      expect(:put => "/wrappages/1").to route_to("wrappages#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/wrappages/1").to route_to("wrappages#destroy", :id => "1")
    end

  end
end
