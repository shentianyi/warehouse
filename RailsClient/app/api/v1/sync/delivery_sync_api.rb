module V1
  module Sync
    class DeliverySyncAPI<SyncBase
      namespace 'deliveries'
      get do
        Delivery.unscoped.where('updated_at>=?', params[:last_time]).all
      end

      post do
        puts params
        delivery=Delivery.new(JSON.parse(params[:delivery]))
        delivery.save
        delivery
      end

      put '/:id' do
        if delivery=Delivery.find_by_id(params[:id])
          delivery.update(JSON.parse(params[:delivery]))
        end
        delivery
      end

      delete '/:id' do
        puts params
        puts params[:delivery]
        if delivery=Delivery.find_by_id(params[:id])
          delivery.update(is_delete: true)
        end
        delivery
      end
    end
  end
end