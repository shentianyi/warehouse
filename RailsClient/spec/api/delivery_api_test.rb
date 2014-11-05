require 'rails_helper'

describe "DeliveryAPIV1" do
  login_admin

  it "show return 10 deliveries" do
    get '/api/v1/deliveries/list/', {:delivery_date => "2014-09-30"}
    expect(JSON.parse(response.body)).to eq(1)
    puts JSON.parse(response)
  end
end