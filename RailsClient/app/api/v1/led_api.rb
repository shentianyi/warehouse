# -*- coding: utf-8 -*-
module V1
  class LedAPI<Base
    namespace :leds do
      guard_all!
      helpers do
        def order_params
          ActionController::Parameters.new(params).require(:order).permit(:id, :current_state)
        end
      end

      # params[:position]
      # params[:state]
      #############need change:  :position -->  :position_id
      post :reset do
        msg=LedService.update_led_state_by_position(params[:position], params[:state])
        msg.result = msg.result ? 1 : 0
        return msg
      end

      # params[:whouse,:part_id]
      get :position_state do

        #  params[:whouse].sub!(/^LO/,'')

        # params[:part_id].sub!(/^P/,'')
        pp = OrderItemService.verify_department(params[:whouse], params[:part_id])
        if pp.nil?
          return {result: 0, content: '库位或零件不存在'}
        end
        led = Led.find_by_position(pp.position.detail)
        if led.nil?
          return {result: 0, content: 'LED灯未找到'}
        end
        ls = LedState.find_by_state(led.current_state)
        if ls.nil?
          return {result: 0, content: 'LED灯状态错误,请重置'}
        end

        requirement = OrderItem.where(created_at: 1.day.ago.utc..Time.now.utc).count
        received = Package.where(created_at: 1.day.ago.utc..Time.now.utc, state: PackageState::RECEIVED).count
        absent = Package.where(created_at: 1.day.ago.utc..Time.now.utc, state: [PackageState::DESTINATION, PackageState::WAY]).count

        {result: 1, content: {id: led.id, position: pp.position.detail, state: led.current_state, requirement: requirement, received: received, absent: absent}}
      end

      get :led_state_list do
        list = []
        LedState.all.order(:state).each do |ls|
          list << {state: ls.state, R: ls.R, G: ls.G, B: ls.B}
        end
        {result: 1, content: list}
      end

      #create 缺货单/需求单
      get :create_stockout_list do
        args = []

        if SysConfigCache.led_enable_value=='false'
          return {result: 0, content: 'LED服务未开启！'}
        end

        position = Position.find_by_id(Led.find_by_name(params[:led_id]).position)
        if position.nil?
          return {result: 0, content: '库位未找到！'}
        end
        part = position.default_part
        if part.nil?
          return {result: 0, content: '零件未找到！'}
        end
        source_id = PartPosition.find_by_part_id(part.id).sourceable_id
        if source_id.nil?
          return {result: 0, content: 'Source Id 未找到！'}
        end
        builder = User.find(SysConfigCache.led_builder_value)
        if builder.nil?
          return {result: 0, content: '创建者未找到！'}
        end
        if params[:box_quantity].nil?
          box_qty = 1
        else
          box_qty = params[:box_quantity]
        end
        quantity = part.unit_pack * box_qty.to_f

        args = [{part_id: part.id, quantity: quantity, box_quantity: box_qty, department: position.whouse.id, is_emergency: params[:is_emergency]}]
        orders = OrderService.create_with_items({order: {source_id: source_id}, order_items: args, nopart_items: args}, builder)
        if orders.nil?
          return {result: 0, content: '需求单创建失败！'}
        else
          return {result: 1, content: '需求单创建成功！'}
        end
      end

    end
  end
end
