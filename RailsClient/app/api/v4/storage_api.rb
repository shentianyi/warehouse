#encoding: utf-8
module V4
  class StorageApi < Base
    namespace :storage do

      desc 'get parts stock by part nrs'
      params do
        requires :part_nrs, type: String, desc: 'part nrs'
      end
      get :parts_stock do
        stocks= StorageService.get_mrp_part_stock_by_nrs(params[:part_nrs].split(';').uniq)
        data=[]
        stocks.each do |stock|
          data<<{
              PartId: stock.partNr,
              Uom: stock.unit.blank? ? '' : stock.unit,
              FIFO: stock.fifo.blank? ? Time.now.utc : stock.fifo.utc,
              ExpireDate: Time.now.years_since(10).utc,
              Qty: stock.qty
          }
        end
        data
      end
    end
  end
end