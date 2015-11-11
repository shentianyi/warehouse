module V3
  class MovementListApi < Grape::API
    namespace :movement_list do
      format :json
      rescue_from :all do |e|
        Rack::Response.new([e.message], 500).finish
      end

      desc 'get history movement list'
      params do
        requires :user_id, type: String, desc: 'movement list builder'
      end
      get do
        time_condition = 7.days.ago.utc...Time.now.utc
        args = []
        movement_lists = MovementList.where(created_at: time_condition, builder: params[:user_id])
        if movement_lists
          movement_lists.each_with_index do |movement_list, index|
            record = {}
            record[:id] = movement_list.id
            record[:created_at] = movement_list.created_at
            record[:count] = movement_list.movements.count
            args[index] = record
          end
          {result: 1, content: args}
        else
          {result: 0, content: "没有数据！"}
        end
      end

      desc 'create movement list'
      params do
        requires :user_id, type: String, desc: 'movement list builder'
        optional :remarks, type: String
      end
      post do
        movement_list = MovementList.new(builder: params[:user_id], name: "#{params[:user_id]}#{DateTime.now.strftime("%H.%d.%m.%Y")}", remarks: params[:remarks])
        if movement_list.save
          {result: 1, content: movement_list}
        else
          {result: 0, content: "创建失败！"}
        end
      end

      desc 'validate movement' #store in class variable
      params do
        requires :toWh, type: String, desc: 'des whouse'
        requires :toPosition, type: String, desc: 'des position'
        optional :fromWh, type: String, desc: 'src whouse'
        optional :fromPosition, type: String, desc: 'src position'
        optional :packageId, type: String, desc: 'package ID'
        optional :partNr, type: String, desc: 'part NO.'
        optional :qty, type: String, desc: 'quantity'
      end
      post :validate_movement do
        params[:toWh]=params[:toWh].sub(/LO/, '')
        params[:toPosition]=params[:toPosition].sub(/LO/, '')
        params[:fromWh]=params[:fromWh].sub(/LO/, '') if params[:fromWh].present?
        params[:fromPosition]=params[:fromPosition].sub(/LO/, '') if params[:fromPosition].present?
        params[:partNr]=params[:partNr].sub(/P/, '') if params[:partNr].present?
        puts "#{params.to_json}-----------"

        begin
          params[:qty]=params[:qty].sub(/Q/, '').to_f if params[:qty].present?
          if params[:partNr].present?
            raise '请填写数量' unless params[:qty].present?
            params[:packageId]=nil
          end

          msg = FileHandler::Excel::NStorageHandler.validate_move_row params
        rescue => e
          if params[:uniq].blank?
            return {result: 0, content: e.message}
          else
            raise e.message
          end
        end

        if msg.result
          {result: 1, content: '数据验证通过.'}
        else
          {result: 0, content: msg.content}
        end

      end

      desc 'save movements'
      params do
        requires :movement_list_id, type: Integer, desc: 'movement list id'
        requires :employee_id, type: String, desc: 'The operator id'
        optional :remarks, type: String, desc: 'note info'
      end
      post :save_movements do

        args = {}
        args[:movement_list_id] = params[:movement_list_id]
        args[:employee_id] = params[:employee_id].sub(/\.0/, '') if params[:employee_id].present?
        args[:remarks] = params[:remarks] if params[:remarks].present?
        args[:user] = current_user
        if params[:movements].blank?
          {result: 0, content: '没有数据移库'}
        else
          params[:movements].each_with_index do |movement, index|
            puts movement
            args[:toWh] = movement[:toWh].sub(/LO/, '')
            args[:toPosition] = movement[:toPosition].sub(/LO/, '')
            args[:fromWh] = movement[:fromWh].sub(/LO/, '') if movement[:fromWh].present?
            args[:fromPosition] = movement[:fromPosition].sub(/LO/, '') if movement[:fromPosition].present?
            args[:partNr] = movement[:partNr].sub(/P/, '') if movement[:partNr].present?
            args[:qty] = movement[:qty].sub(/Q/, '').to_f if movement[:qty].present?

            begin
              if movement[:partNr].present?
                raise '请填写数量' unless movement[:qty].present?
                args[:packageId]=nil
              end
              NStorage.transaction do
                WhouseService.new.move(args)
              end
            rescue => e
              return {result: 0, content: e.message}
            end
          end
          {result: 1, content: '移库成功'}
        end
      end


    end
  end
end