class OrderBoxService
  # require
  #  nr:string
  def self.detail nr
    if ob=OrderBox.find_by_nr(nr)
      OrderBoxPresenter.new(ob).as_basic_feedback
    else
      ApiMessage.new({
                         meta: {
                             code: 400,
                             error_message: '未找到该料盒'
                         }
                     })
    end
  end

  def self.details nrs
    order_boxes=[]
    nrs.each do |nr|
      if ob=OrderBox.find_by_nr(nr)
        order_boxes<< OrderBoxPresenter.new(ob).as_data
      end
    end
    ApiMessage.new({
                       meta: {
                           code: 200
                       },
                       data: order_boxes
                   })

  end

  def self.weight_box(params)
p params
p '---------------------------------------------'
    id=params[:id]
    pick_item_id= params[:pick_item_id]
    if box=OrderBox.find_by_id(id)
      box.update_attributes(status: OrderBoxStatus::PICKED)
    end
    if item=PickItem.find_by_id(pick_item_id)
      item.update_attributes(state: PickItemStatus::PICKED,
                             weight: params[:weight],
                             weight_qty: params[:weight_qty],
                             weight_valid: params[:weight_valid])
    end

    {
        meta: {
            code: 200,
            message: '称重成功'
        }
    }
  end

  def self.bind_led(params)
    p params
    p '---------------------------------------------'
    if box=OrderBox.find_by_nr(params[:id])
      unless box.update_attributes(led_id: params[:led_id])
        {
            meta: {
                code: 400,
                message: '绑定失败'
            }
        }
      end
    else
      return     {
          meta: {
              code: 400,
              message: '未找到该料盒'
          }
      }
    end

    {
        meta: {
            code: 200,
            message: '绑定成功'
        }
    }
  end
end