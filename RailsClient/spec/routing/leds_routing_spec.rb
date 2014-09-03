require "rails_helper"

RSpec.describe LedsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/leds").to route_to("leds#index")
    end

    it "routes to #new" do
      expect(:get => "/leds/new").to route_to("leds#new")
    end

    it "routes to #show" do
      expect(:get => "/leds/1").to route_to("leds#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/leds/1/edit").to route_to("leds#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/leds").to route_to("leds#create")
    end

    it "routes to #update" do
      expect(:put => "/leds/1").to route_to("leds#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/leds/1").to route_to("leds#destroy", :id => "1")
    end

  end
end
