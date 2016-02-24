require "rails_helper"

RSpec.describe PartClientsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/part_clients").to route_to("part_clients#index")
    end

    it "routes to #new" do
      expect(:get => "/part_clients/new").to route_to("part_clients#new")
    end

    it "routes to #show" do
      expect(:get => "/part_clients/1").to route_to("part_clients#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/part_clients/1/edit").to route_to("part_clients#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/part_clients").to route_to("part_clients#create")
    end

    it "routes to #update" do
      expect(:put => "/part_clients/1").to route_to("part_clients#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/part_clients/1").to route_to("part_clients#destroy", :id => "1")
    end

  end
end
