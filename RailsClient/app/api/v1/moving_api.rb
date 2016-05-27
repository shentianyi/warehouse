module V1
  class MovingAPI<Base
    include APIGuard
    namespace :moving do
      guard_all!

      desc 'Stock Move.'
      params do
        # requires :fifo, type: String, desc: 'require fifo'
        requires :toWh, type: String, desc: 'require toWh(to warehouse, whId)'
        requires :toPosition, type: String, desc: 'require toPosition'
        # requires :type, type: String, desc: 'require move type'
        optional :fromWh, type: String, desc: 'require toWh(to warehouse, whId)'
        optional :fromPosition, type: String, desc: 'require toPosition'
        optional :qty, type: String, desc: 'require qty(quantity)'
        optional :partNr, type: String
        optional :uniqueId, type: String
        optional :packageId, type: String
        optional :fifo, type: String
      end
      post :move do
        params[:toWh]=params[:toWh] #.sub(/LO/, '')
        params[:toPosition]=params[:toPosition] #.sub(/LO/, '')
        params[:fromWh]=params[:fromWh] if params[:fromWh].present?
        params[:fromPosition]=params[:fromPosition] if params[:fromPosition].present?

        params[:partNr]=params[:partNr] if params[:partNr].present?
        params[:user] = current_user
        puts "#{params.to_json}-----------"
        begin
          params[:qty]=params[:qty] if params[:qty].present?
          if params[:partNr].present?
            raise '请填写数量' unless params[:qty].present?
            params[:packageId]=nil
          end

          msg = FileHandler::Excel::NStorageHandler.validate_move_row params
          unless msg.result
            return {result: 0, content: msg.content}
          end

          NStorage.transaction do
            WhouseService.new.move(params)
          end
        rescue => e
          if params[:uniq].blank?
            return {result: 0, content: e.message}
          else
            raise e.message
          end
        end
        {result: 1, content: '移库成功'}
      end

      def to_json
        {
            position_id: self.position_id
        }
      end

      post :rt_position do
        msg=Message.new
        begin
          warehouse_id=Whouse.where(nr: params[:warehouse]).select("id")
          position_id= Position.where(nr: params[:position]).select("id")

          puts("sfaskfjsalfk")
          puts(position_id.to_a)
          puts(position_id.to_a[0])
          puts(position_id.to_a[0].id)

          if position_id.to_a == " "
            return {result: 0, unfill: '库位不存在'}
          else
            get_warehouse_id=(warehouse_id.to_a[0].id)
            get_position_id=(position_id.to_a[0].id)

            #max_position_count = SysConfig.where(code: 'CAPACITY_SERVER').select("value")
            max_position_count = SysConfig.where(code: 'CAPACITY_NR').to_a[0].value.to_i

            puts("Get Position ID ========")
            puts(get_position_id)

            if warehouse=NStorage.where(:ware_house_id => get_warehouse_id, :position_id => get_position_id).count("ware_house_id")
              if warehouse < max_position_count

                #count={
                #    warehouse:warehouse,
                #    max_position_count:max_position_count
                #
                #}
                #return {result: 0, unfill: count}
                return {result: 0, unfill: warehouse}

                puts ('success  0==================')
                puts (warehouse)
              else
                return {result: 1, unfill: '库位已满'}
              end
            else
              return {result: 0, unfill: '数据库查询失败'}
            end
          end
        rescue => e
          msg.content=e.message
          puts ('e.message==================')
          puts (msg.content)
        end

        puts(msg.content)
      end


      post :enter do
        msg=Message.new
        begin
          if warehouse=current_user.location.whouses.where(nr: params[:warehouse]).first
            if position=warehouse.positions.where(nr: params[:position]).first
              if (lc=LogisticsContainer.last_lc_container(params[:container]))
                if msg.result=lc.get_service.enter_stock(current_user, lc, warehouse, position, Time.now.utc)
                  msg.content='入库成功'
                else
                  msg.content='入库失败'
                end
              else
                msg.content='扫描码不存在'
              end
            else
              msg.content='库位不存在'
            end
          else
            msg.content='仓库不存在'
          end
        rescue => e
          msg.content=e.message
        end
        msg
      end
    end
  end
end
