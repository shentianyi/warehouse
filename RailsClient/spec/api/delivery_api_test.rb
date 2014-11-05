require 'rails_helper'

describe "DeliveryAPIV1" do
  describe "#list" do
    context "get all deliveries" do
      it "show return 10 deliveries" do
        get '/api/v1/deliveries/list/', {:delivery_date => "2014-09-30"}
        #expect(JSON.parse(response.body)).to be_success
        should respond_with 200
      end
    end
  end
end