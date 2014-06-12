class ApplicationAPI < Grape::API


  format :json

  mount V1::Base
  mount V1::Service::ServiceBase
  mount V1::Sync::SyncBase
end
