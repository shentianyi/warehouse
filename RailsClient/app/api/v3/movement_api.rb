module V3
  class MovementApi < Grape::API
    namespace :movement do
      format :json
      rescue_from :all do |e|
        Rack::Response.new([e.message], 500).finish
      end

      desc 'get movements'
      params do
        requires :movement_list_id, type: Integer, desc: 'movement list id'
      end
      get do
        args = []
        movements = Movement.where(movement_list_id: params[:movement_list_id])
        if movements.blank?
          {result: 0, content: "没有数据！"}
        else
          movements.each_with_index do |movement, index|
            record = {}
            record[:id] = movement.id
            record[:toPosition] = movement.toPosition
            record[:partNr] = movement.partNr
            record[:qty] = movement.qty
            record[:fifo] = movement.fifo
            args[index] = record
          end
          {result: 1, content: args}
        end
      end

      desc 'get movement detail'
      params do
        requires :movement_id, type: Integer, desc: 'movement id'
      end
      get :movement_detail do
        movement = Movement.find_by(id: params[:movement_id])
        if movement.blank?
          {result: 0, content: "没有数据！"}
        else
          args = {}
          args[:id] = movement.id
          args[:fromWh] = movement.from_id
          args[:fromPosition] = movement.fromPosition
          args[:fifo] = movement.fifo
          args[:toWh] = movement.to_id
          args[:toPosition] = movement.toPosition
          args[:packageId] = movement.packageId
          args[:partNr] = movement.partNr
          args[:qty] = movement.qty
          args[:fifo] = movement.fifo
          {result: 1, content: args}
        end
      end

    end
  end
end