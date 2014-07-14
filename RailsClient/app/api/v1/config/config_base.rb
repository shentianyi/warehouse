module V1
  module Config
    class ConfigBase < ApplicationAPI
      include OauthAPIGuard
      version 'v1', :using => :path
      namespace 'config'

    end
  end
end
