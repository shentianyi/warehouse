module V1
  module Sync
    class DeliverySyncAPI<SyncBase
      namespace 'deliveries'
      rescue_from :all do |e|
        DeliverySyncAPI.error_unlock_sync_pool('deliveries')
        Rack::Response.new([e.message], 500).finish
      end
      get do
        #raise SignalException
        Delivery.unscoped.where('updated_at>=?', params[:last_time]).all
      end

      post do
        msg=Message.new
        begin
          ActiveRecord::Base.transaction do
            deliveries=JSON.parse(params[:delivery])
            deliveries.each do |delivery|
              delivery=Delivery.new(delivery)
              delivery.save
            end
          end
          msg.result =true
        rescue => e
          msg.content = "post:#{e.message}"
        end
        return msg
      end

      put '/:id' do
        msg=Message.new
        begin
          ActiveRecord::Base.transaction do
            deliveries=JSON.parse(params[:delivery])
            deliveries.each do |delivery|
              if u=Delivery.unscoped.find_by_id(delivery['id'])
                u.update(delivery.except('id'))
              end
            end
          end
          msg.result =true
        rescue => e
          msg.content = "put:#{e.message}"
        end
        return msg
      end

      post :delete do
        msg=Message.new
        begin
          ActiveRecord::Base.transaction do
            deliveries=JSON.parse(params[:delivery])
            deliveries.each do |id|
              if delivery=Delivery.unscoped.find_by_id(id)
                delivery.update(is_delete: true)
              end
            end
          end
          msg.result =true
        rescue => e
          msg.content = "delete:#{e.message}"
        end
        return msg
      end
    end
  end
end