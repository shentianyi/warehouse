class OrderCarService
  # require
  #  nr:string
  def self.details nr
    if oc=OrderCar.find_by_nr(nr)
      OrderCarPresenter.new(oc).as_basic_feedback
    else
      ApiMessage.new({
                         meta: {
                             code: 400,
                             error_message: '未找到该料车'
                         }
                     })
    end
  end


  def self.bind_led_box params
    OrderCar.transaction do
      validable_led_and_box(params) do |box, led|
        box.led=led
        if box.save
          {
              meta: {
                  code: 200,
                  message: 'Bind Success'
              }
          }
        else
          ApiMessage.new({meta: {code: 400, error_message: 'Bind Failed'}})
        end
      end
    end
  end


  def self.validable_led_and_box params
    if car=OrderCar.find_by_nr(params[:nr])
      err_infos=[]
      unless box=OrderBox.find_by_nr(params[:order_box_nr])
        err_infos<<"料盒#{params[:order_box_nr]}没有找到!"
      end

      unless led=car.leds.where(id: params[:led_id]).first
        err_infos<<"LED:#{params[:order_box_nr]}不在料车:#{car.nr}上!"
      end

      if err_infos.size==0
        if block_given?
          yield(box, led)
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

end