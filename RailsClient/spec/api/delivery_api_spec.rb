require 'rails_helper'

describe "DeliveryAPIV1" do
  #login_as_admin
  before(:each) do
    login_as_sender
  end

  it "show return 10 deliveries" do
    get '/api/v1/deliveries/list/', {:delivery_date => "2014-09-30"}
    expect(response.status).to eq(200)
  end
end