require 'rails_helper'

RSpec.describe "SysConfigs", :type => :request do
  describe "GET /sys_configs" do
    it "works! (now write some real specs)" do
      get sys_configs_path
      expect(response.status).to be(200)
    end
  end
end
