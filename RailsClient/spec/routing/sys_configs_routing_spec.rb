require "rails_helper"

RSpec.describe SysConfigsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/sys_configs").to route_to("sys_configs#index")
    end

    it "routes to #new" do
      expect(:get => "/sys_configs/new").to route_to("sys_configs#new")
    end

    it "routes to #show" do
      expect(:get => "/sys_configs/1").to route_to("sys_configs#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/sys_configs/1/edit").to route_to("sys_configs#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/sys_configs").to route_to("sys_configs#create")
    end

    it "routes to #update" do
      expect(:put => "/sys_configs/1").to route_to("sys_configs#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/sys_configs/1").to route_to("sys_configs#destroy", :id => "1")
    end

  end
end
