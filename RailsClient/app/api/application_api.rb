class ApplicationAPI < Grape::API


  format :json

  mount V1::Sync::SyncBase
  mount V1::Base
end
