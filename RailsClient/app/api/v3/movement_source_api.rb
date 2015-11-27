module V3
  class MovementSourceApi < Base
    namespace :movement_source do
      guard_all!

      format :json
      rescue_from :all do |e|
        Rack::Response.new([e.message], 500).finish
      end

      desc 'get movement_sources'
      params do
        requires :movement_list_id, type: String, desc: 'movement list id'
      end
      get do
        args = []
        movement_sources = MovementSource.where(movement_list_id: params[:movement_list_id])
        if movement_sources.blank?
          {result: 0, content: "没有数据！"}
        else
          movement_sources.each_with_index do |movement_source, index|
            record = {}
            record[:id] = movement_source.id
            record[:toWh] = movement_source.toWh
            record[:toPosition] = movement_source.toPosition
            record[:partNr] = movement_source.partNr
            record[:fifo] = movement_source.fifo
            args[index] = record
          end
          {result: 1, content: args}
        end
      end

      desc 'get movement source detail'
      params do
        requires :movement_source_id, type: Integer, desc: 'movement source id'
      end
      get :movement_source_detail do
        movement_source = MovementSource.find_by(id: params[:movement_source_id])
        if movement_source.blank?
          {result: 0, content: "没有数据！"}
        else
          args = {}
          args[:id] = movement_source.id
          args[:fromWh] = movement_source.fromWh
          args[:fromPosition] = movement_source.fromPosition
          args[:fifo] = movement_source.fifo
          args[:toWh] = movement_source.toWh
          args[:toPosition] = movement_source.toPosition
          args[:packageId] = movement_source.packageId
          args[:partNr] = movement_source.partNr
          args[:qty] = movement_source.qty
          args[:fifo] = movement_source.fifo
          {result: 1, content: args}
        end
      end

      desc 'delete movement_source'
      params do
        requires :movement_source_id, type: Integer, desc: 'ID of the movement_source'
      end
      delete do
        m = MovementSource.find_by(id: params[:movement_source_id])
        if m && m.movement_list
          return {result: 0, content: "该记录所属移库单已经移库成功, 不可删除！"} if m.movement_list.state == "成功"
        end

        m.destroy
        {result: 1, content: "删除成功"}
      end

    end
  end
end