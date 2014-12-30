class ApplicationAPI < Grape::API

  content_type :json, 'application/json;charset=UTF-8'
  format :json

  mount V1::Base
  mount V1::Service::ServiceBase
  mount V1::Sync::SyncBase
  mount V2::Base
end
