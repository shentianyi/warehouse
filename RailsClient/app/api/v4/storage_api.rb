#encoding: utf-8
module V4
  class StorageApi < Base
    namespace :storage do

      desc 'get parts stock by part nrs'
      params do
        requires :part_nrs, type: Array, desc: 'part nrs'
      end
      get :parts_stock do
        stocks= StorageService.get_mrp_part_stock_by_nrs(params[:part_nrs].uniq)
        data=[]
        stocks.each do |stock|
          data<<{
              PartNr: stock.partNr,
              Uom: stock.unit,
              FIFO: stock.fifo,
              ExpireDate: Time.now.years_since(10).utc,
              Qty: stock.qty
          }
        end
      end
    end
  end
end