require 'rails_helper'

describe "DeliveryAPIV1" do
  describe "#list" do
    context "get all deliveries" do
      it "show return 10 deliveries" do
        get '/api/v1/deliveries/list'
      end
    end
  end
end