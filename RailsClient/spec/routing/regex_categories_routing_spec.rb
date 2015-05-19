require "rails_helper"

RSpec.describe RegexCategoriesController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/regex_categories").to route_to("regex_categories#index")
    end

    it "routes to #new" do
      expect(:get => "/regex_categories/new").to route_to("regex_categories#new")
    end

    it "routes to #show" do
      expect(:get => "/regex_categories/1").to route_to("regex_categories#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/regex_categories/1/edit").to route_to("regex_categories#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/regex_categories").to route_to("regex_categories#create")
    end

    it "routes to #update" do
      expect(:put => "/regex_categories/1").to route_to("regex_categories#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/regex_categories/1").to route_to("regex_categories#destroy", :id => "1")
    end

  end
end
