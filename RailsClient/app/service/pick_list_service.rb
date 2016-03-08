class PickListService
  def self.covert_order_to_pick_list user_id, order_ids
    order_items=PickItemService.get_order_items(user_id, order_ids)
    if order_items && order_items.count>0
      pick_list=PickList.new(user_id: user_id,order_ids:order_ids.join(';'))
      order_items.each do |i|
        pick_list.pick_items<<PickItem.new(
            quantity: i.quantity,
            box_quantity: i.box_quantity,
            destination_whouse_id: i.whouse_id,
            user_id: i.user_id,
            part_id: i.part_id,
            part_type_id: i.part_type_id,
            remark: i.remark,
            is_emergency: i.is_emergency,
            order_item_id: i.id
        )
        i.update(handled:true)
      end
      remark = ""
      OrderService.find({id:order_ids}).each do |o|
        o.update(status:OrderState::PRINTED)
        remark+= o.remark
      end
      pick_list.remark = remark
      pick_list.save
      return pick_list
    end
  end

  #-------------
  #find_by_days
  #params
  #@user
  #@days = 3
  #-------------
  def self.find_by_days user,days=3
    start_t = 3.day.ago.at_beginning_of_day.utc
    end_t = Time.now.at_end_of_day.utc
    condition = {
        :created_at => start_t..end_t,
        :user_id => user.id,
    }
    PickList.where(condition).all.order(created_at: :desc)
  end

  ###########################################################################################
  # require
  #  nr:string
  def self.create_by_car user, params
    #begin
    PickList.transaction do
      validable_car_and_box(params) do |car, boxs|
        order=Order.new(status: OrderStatus::PICKING)
        order.user=user
        order.whouse=car.whouse

        order.orderable=car
        car.update_attributes(status: OrderCarStatus::PICKING)
        car.orders<<order
        boxs.each do |box|
          box.update_attributes(status: OrderBoxStatus::PICKING)
          order_item=OrderItem.new({
                                       quantity: box.quantity,
                                       part_id: box.part_id,
                                       is_emergency: false
                                   })
          order_item.user=user
          order_item.order=order
          order_item.orderable=box
          box.order_items<<order_item
          order.order_items<<order_item
        end

        pick=PickList.new(state: PickStatus::PICKING)
        pick.user=user

        order.order_items.each do |item|
          order_box=item.orderable
          pick_item=PickItem.new(
              destination_whouse_id: order_box.source_whouse_id,
              part_id: item.part_id,
              quantity: item.quantity,
              state: PickStatus::PICKING
          )
          if position=Position.where(whouse_id: order_box.source_whouse_id, id: PartPosition.where(part_id: item.part_id).pluck(:position_id)).first
            pick_item.position=position
          end
          pick_item.order_item=item
          pick.pick_items<<pick_item
        end

        pick.orders<<order

        if pick.save
          {
              meta: {
                  code: 200,
                  message: 'Creates Success'
              },
              data: PickListPresenter.new(pick).as_basic_info
          }
        else
          ApiMessage.new({meta: {code: 400, error_message: '生成需求单失败'}})
        end
      end
    end
    # rescue => e
    #   ApiMessage.new({meta: {code: 400, message: e.message}})
    # end
  end

  def self.validable_car_and_box params
    if car=OrderCar.find_by_id(params[:order_car_id])
      err_infos=[]
      boxs=nil
      p params
      if params[:order_box_ids].present?
        boxs=[]
        params[:order_box_ids].each do |box_id|
          unless box=OrderBox.find_by_id(box_id)
            err_infos<<"料盒#{box_id}没有找到!"
          end
          boxs<<box
        end
      end

      if err_infos.size==0
        if block_given?
          yield(car, boxs)
        else
          ApiMessage.new({meta: {code: 200, error_message: '数据验证通过'}})
        end
      else
        ApiMessage.new({meta: {code: 400, error_message: err_infos.join(',')}})
      end
    else
      ApiMessage.new({meta: {code: 400, error_message: '料车没有找到'}})
    end
  end


  def self.by_status status
    PickListPresenter.as_details(PickList.where(state: status).all)
  end
end