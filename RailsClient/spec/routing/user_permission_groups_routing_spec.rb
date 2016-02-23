require "rails_helper"

RSpec.describe UserPermissionGroupsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/user_permission_groups").to route_to("user_permission_groups#index")
    end

    it "routes to #new" do
      expect(:get => "/user_permission_groups/new").to route_to("user_permission_groups#new")
    end

    it "routes to #show" do
      expect(:get => "/user_permission_groups/1").to route_to("user_permission_groups#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/user_permission_groups/1/edit").to route_to("user_permission_groups#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/user_permission_groups").to route_to("user_permission_groups#create")
    end

    it "routes to #update" do
      expect(:put => "/user_permission_groups/1").to route_to("user_permission_groups#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/user_permission_groups/1").to route_to("user_permission_groups#destroy", :id => "1")
    end

  end
end
