require 'rails_helper'
describe "PackageAPIV1" do

  before(:each) do
    login_as_sender
    @t = create(:terminator)
  end

  it "create one package" do
    post '/api/v1/packages',{package:{id:'WI001',part_id:@t.id,quantity_str:'Q100',check_in_time:"12 10 11"}}
    expect(JSON.parse(response.body)['result']).to eq(1)
  end
end