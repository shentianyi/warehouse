require "rails_helper"

RSpec.describe ModemsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/modems").to route_to("modems#index")
    end

    it "routes to #new" do
      expect(:get => "/modems/new").to route_to("modems#new")
    end

    it "routes to #show" do
      expect(:get => "/modems/1").to route_to("modems#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/modems/1/edit").to route_to("modems#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/modems").to route_to("modems#create")
    end

    it "routes to #update" do
      expect(:put => "/modems/1").to route_to("modems#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/modems/1").to route_to("modems#destroy", :id => "1")
    end

  end
end
