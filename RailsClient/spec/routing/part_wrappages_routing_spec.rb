require "rails_helper"

RSpec.describe PartWrappagesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/part_wrappages").to route_to("part_wrappages#index")
    end

    it "routes to #new" do
      expect(:get => "/part_wrappages/new").to route_to("part_wrappages#new")
    end

    it "routes to #show" do
      expect(:get => "/part_wrappages/1").to route_to("part_wrappages#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/part_wrappages/1/edit").to route_to("part_wrappages#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/part_wrappages").to route_to("part_wrappages#create")
    end

    it "routes to #update" do
      expect(:put => "/part_wrappages/1").to route_to("part_wrappages#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/part_wrappages/1").to route_to("part_wrappages#destroy", :id => "1")
    end

  end
end
