require "rails_helper"

RSpec.describe PartTypesController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/part_types").to route_to("part_types#index")
    end

    it "routes to #new" do
      expect(:get => "/part_types/new").to route_to("part_types#new")
    end

    it "routes to #show" do
      expect(:get => "/part_types/1").to route_to("part_types#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/part_types/1/edit").to route_to("part_types#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/part_types").to route_to("part_types#create")
    end

    it "routes to #update" do
      expect(:put => "/part_types/1").to route_to("part_types#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/part_types/1").to route_to("part_types#destroy", :id => "1")
    end

  end
end
