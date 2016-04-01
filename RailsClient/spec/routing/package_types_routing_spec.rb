require "rails_helper"

RSpec.describe PackageTypesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/package_types").to route_to("package_types#index")
    end

    it "routes to #new" do
      expect(:get => "/package_types/new").to route_to("package_types#new")
    end

    it "routes to #show" do
      expect(:get => "/package_types/1").to route_to("package_types#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/package_types/1/edit").to route_to("package_types#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/package_types").to route_to("package_types#create")
    end

    it "routes to #update" do
      expect(:put => "/package_types/1").to route_to("package_types#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/package_types/1").to route_to("package_types#destroy", :id => "1")
    end

  end
end
