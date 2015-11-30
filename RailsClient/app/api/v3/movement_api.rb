module V3
  class MovementApi < Base
    namespace :movement do
      guard_all!

      format :json
      rescue_from :all do |e|
        Rack::Response.new([e.message], 500).finish
      end

      desc 'get movements'
      params do
        requires :movement_list_id, type: String, desc: 'movement list id'
      end
      get do
        args = []
        puts '9999999999999999999999999999999999999999'

        movements = MovementSource.where(movement_list_id: params[:movement_list_id])
        puts '555555555555555555555555555555555555555'

        if movements.blank?
          {result: 0, content: "没有数据！"}
        else
          movements.each_with_index do |movement, index|
            record = {}
            record[:id] = movement.id
            record[:toWh] = movement.toWh
            record[:toPosition] = movement.toPosition
            record[:partNr] = movement.partNr
            record[:qty] = movement.qty
            record[:fifo] = movement.fifo
            record[:fromWh] = movement.fromWh
            record[:fromPosition] = movement.fromPosition
            record[:packageId] = movement.packageId

            args[index] = record
          end
          {result: 1, content: args}
        end
      end

      desc 'get movement detail'
      params do
        requires :movement_id, type: String, desc: 'movement id'
      end
      get :movement_detail do
        movement = MovementSource.find_by(id: params[:movement_id])
        if movement.blank?
          {result: 0, content: "没有数据！"}
        else
          args = {}
          args[:id] = movement.id
          args[:fromWh] = movement.fromWh
          args[:fromPosition] = movement.fromPosition
          args[:fifo] = movement.fifo
          args[:toWh] = movement.toWh
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