module V1
  module Config
    class ConfigBase < ApplicationAPI
      #include OauthAPIGuard
      include APIGuard
      version 'v1', :using => :path
      #mount IosUpdateAPI
    end
  end
end
