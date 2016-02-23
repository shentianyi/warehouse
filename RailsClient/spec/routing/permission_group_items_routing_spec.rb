require "rails_helper"

RSpec.describe PermissionGroupItemsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/permission_group_items").to route_to("permission_group_items#index")
    end

    it "routes to #new" do
      expect(:get => "/permission_group_items/new").to route_to("permission_group_items#new")
    end

    it "routes to #show" do
      expect(:get => "/permission_group_items/1").to route_to("permission_group_items#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/permission_group_items/1/edit").to route_to("permission_group_items#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/permission_group_items").to route_to("permission_group_items#create")
    end

    it "routes to #update" do
      expect(:put => "/permission_group_items/1").to route_to("permission_group_items#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/permission_group_items/1").to route_to("permission_group_items#destroy", :id => "1")
    end

  end
end
