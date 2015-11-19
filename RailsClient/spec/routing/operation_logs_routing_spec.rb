require "rails_helper"

RSpec.describe OperationLogsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/operation_logs").to route_to("operation_logs#index")
    end

    it "routes to #new" do
      expect(:get => "/operation_logs/new").to route_to("operation_logs#new")
    end

    it "routes to #show" do
      expect(:get => "/operation_logs/1").to route_to("operation_logs#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/operation_logs/1/edit").to route_to("operation_logs#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/operation_logs").to route_to("operation_logs#create")
    end

    it "routes to #update" do
      expect(:put => "/operation_logs/1").to route_to("operation_logs#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/operation_logs/1").to route_to("operation_logs#destroy", :id => "1")
    end

  end
end
