require "rails_helper"

RSpec.describe WrappageMovementsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/wrappage_movements").to route_to("wrappage_movements#index")
    end

    it "routes to #new" do
      expect(:get => "/wrappage_movements/new").to route_to("wrappage_movements#new")
    end

    it "routes to #show" do
      expect(:get => "/wrappage_movements/1").to route_to("wrappage_movements#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/wrappage_movements/1/edit").to route_to("wrappage_movements#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/wrappage_movements").to route_to("wrappage_movements#create")
    end

    it "routes to #update" do
      expect(:put => "/wrappage_movements/1").to route_to("wrappage_movements#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/wrappage_movements/1").to route_to("wrappage_movements#destroy", :id => "1")
    end

  end
end
