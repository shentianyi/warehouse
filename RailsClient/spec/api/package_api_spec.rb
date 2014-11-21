require 'rails_helper'
describe "PackageAPIV1" do

  before(:each) do
  	@package_url = '/api/v1/packages'
    login_as_sender
    @t = create(:terminator)

    #create packages
    1.times.each do |i|
      package_id = "WI00#{i+1}"
      PackageService.create({package:{id:package_id,quantity_str:"Q100.0",check_in_time:"10.10.14",part_id:1}},@sender)
    end
  end

  it "validate package id should get result 1" do
  	post @package_url+'/validate', {id:"W001"}
  	expect(JSON.parse(response.body)['result']).to eq(1)
  end

  it "validate quantity number should get result 1" do
  	post @package_url+'/validate_quantity',{quantity_str:"Q100.0"}
  	expect(JSON.parse(response.body)['result']).to eq(1)
  end

  it "validate part id" do

  end

  it "should get packages" do
  	post @package_url+'/binds',{}
  	puts "======="
  	#expect(JSON.parse(response.body))
  	expect(response.status).to eq(201)
  end

  it "create 1 package" do
  	post '/api/v1/packages',{package:{id:'W001',part_id:@t.id,quantity_str:'Q100',check_in_time:"1.10.14"}}
  	expect(JSON.parse(response.body)['result']).to eq(1)
  end

  it "update package" do

  end
end