# -*- coding: utf-8 -*-

module V1
  class DeliveryAPI<Base
    namespace :deliveries
    guard_all!

    #strong parameters
    helpers do
      def delivery_params
        ActionController::Parameters.new(params).require(:delivery).permit(:id, :destination_id, :user_id, :delivery_date, :forklifts, :remark)
      end
    end

    #get by create at time and state
    #@start_time
    #@end_time
    #@state
    #@type 0=> sent from my location
    #1 => sent to my location
    # 2014-11-24 => 搜索结果很慢，参数 start_time:2014-8-10 end_time:2014-10-1 type:0 结果760条左右运单，消耗75秒！！！
    get :get_by_time_and_state do
      args = {}
      start_time = params[:start_time].nil? ? 48.hour.ago : Time.parse(params[:start_time])
      end_time = params[:end_time].nil? ? Time.now : Time.parse(params[:end_time])

      args[:state] = params[:state] if params[:state]

      if params[:type].nil? || params[:type].to_i == 0
        args[:created_at] = start_time..end_time
        args[:source_location_id] = [current_user.location_id,nil]
        #args[:user_id] = current_user.id
        args[:user_id] = current_user.id if params[:all].nil?
      else
        args['records.impl_time'] = start_time..end_time
        args['records.impl_user_type'] = ImplUserType::RECEIVER
        args[:des_location_id] = current_user.location_id
      end

      args[:ancestry]= nil

      #数据量太大，最多只支持50个运单
      {result: 1, content: DeliveryPresenter.init_json_presenters(DeliveryService.search(args).order(created_at: :desc).limit(50))}
    end

    get :forklifts do
      msg = ApiMessage.new

      unless lc = LogisticsContainer.exists?(params[:id])
        return msg.set_false(DeliveryMessage::NotExist)
      end

      dpresenger = DeliveryPresenter.new(lc)

      {result:1,content: ForkliftPresenter.init_json_presenters(dpresenger.forklifts)}
    end

    # check forklift
    # forklift id
    # *need to move this api to forklift*
    # *2014-11-28 这里有个问题，can_copy?有问题，需要修改
    post :check_forklift do
      unless Forklift.exists?(params[:forklift_id])
        return {result: 0, content: DeliveryMessage::CheckForkliftFailed}
      end

      lc = LogisticsContainer.find_latest_by_container_id(params[:forklift_id])

      unless lc.can_copy?
        return {resule: 0, content: ForkliftMessage::CannotAdd}
      end

      f = nil

      if lc.base_state == CZ::State::INIT
        f = lc
      else
        f=LogisticsContainer.build(params[:forklift_id], current_user.id, current_user.location_id)
      end

      if f.root?
        {result: 1, content: ForkliftPresenter.new(f).to_json}
      else
        {result: 0, content: DeliveryMessage::CheckForkliftFailed}
      end
    end

    # add forklift to delivery
    # id: delivery id
    # forklift: forklift ids
    #
    post :add_forklift do
      unless d = LogisticsContainer.exists?(params[:id])
        return {result: 0, content: DeliveryMessage::NotExit}
      end

      unless Forklift.where(id: params[:forklifts]).count == params[:forklifts].length
        return {result: 0, content: DeliveryMessage::ForkliftHasNotExist}
      end

      unless LogisticsContainer.are_roots?(params[:forklifts], current_user.location_id)
        return {result: 0, content: DeliveryMessage::ForkliftExistInOthers}
      end

      unless d.can_update?
        return {result: 0, content: DeliveryMessage::CannotUpdate}
      end

      if d.add_by_ids(params[:forklifts])
        {result: 1, content: DeliveryMessage::AddForkliftSuccess}
      else
        {result: 0, content: ''}
      end
    end

    # remove forklift
    # id is forklift_id
    delete :remove_forklift do
      unless f = LogisticsContainer.exists?(params[:forklift_id])
        return {result: 0, content: ForkliftMessage::NotExit}
      end

      unless f.can_delete?
        return {result: 0, content: DeliveryMessage::DeleteForkliftFailed}
      end

      result =f.remove
      if result
        {result: 1, content: DeliveryMessage::DeleteForkliftSuccess}
      else
        {result: 0, content: DeliveryMessage::DeleteForkliftFailed}
      end
    end

    # send delivery
    #**
    #@deprecated
    #**
    post :send do
      msg = ApiMessage.new

      unless lc = LogisticsContainer.exists?(params[:id])
        return msg.set_false(DeliveryMessage::NotExist)
      end

      unless lc.can_update?
        return msg.set_false(DeliveryMessage::CannotUpdate)
      end

      unless destination = Location.find_by_id(params[:destination_id])
        return msg.set_false(DeliveryMessage::DestinationNotExist)
      end

      #lc.dispatch
      #*different type of logistics_container should have its own implementation of dispatch*
      unless (r = DeliveryService.dispatch(lc,destination,current_user)).result
        return msg.set_false(r.content)
      end

      return msg.set_true(DeliveryMessage::SendSuccess)
    end

    #create delivery
    #@forklifts : forklift ids
    post do
      container_ids = []
      if params[:forklifts] && params[:forklifts].length>0
        unless (fs = LogisticsContainerService.search({id: params[:forklifts]}).all).count == params[:forklifts].length
          return {result: 0, content: DeliveryMessage::ForkliftHasNotExist}
        end

        container_ids = fs.collect{|f|f.container_id}

        unless LogisticsContainer.are_roots?(container_ids, current_user.location_id)
          return {result: 0, content: DeliveryMessage::ForkliftExistInOthers}
        end
      end

      msg = DeliveryService.create(delivery_params, current_user)

      if params.has_key?(:forklifts)
        msg.object.add_by_ids(container_ids)
      end
      #
      if msg.result
        {result: 1, content: DeliveryPresenter.new(msg.object).to_json}
      else
        {result: 0, content: msg.content}
      end
    end

    # delete delivery
    #@id
    delete do
      msg = LogisticsContainerService.destroy_by_id(params[:id])
      if msg.result
        {result: 1, content: BaseMessage::DESTROYED}
      else
        {result: 0, content: msg.content}
      end
    end

    # get delivery detail
    get :detail do
      msg = ApiMessage.new
      unless lc = LogisticsContainer.exists?(params[:id])
        return msg.set_false(DeliveryMessage::NotExist)
      end
      content = DeliveryPresenter.new(lc).to_json
      msg.set_true(content)
    end

    # update delivery
    put do
      msg = ApiMessage.new
      args=delivery_params
      if (d = LogisticsContainer.exists?(args[:id])).nil?
        return msg.set_false(DeliveryMessage::NotExist)
      end

      unless d.can_update?
        return msg.set_false(DeliveryMessage::CannotUpdate)
      end

      if d.update_attributes(remark:args[:remark])
        return msg.set_true(DeliveryMessage::UpdateSuccess)
      else
        return msg.set_false(DeliveryMessage::UpdateFailed)
      end
    end

    #**
    #@deprecated
    #**
    # receive delivery
    post :receive do
      #这里的id其实是container_id，因为扫描的是运单号
      unless d = LogisticsContainer.find_latest_by_container_id(params[:id])
        return {return: 0, content: DeliveryMessage::NotExist}
      end

      #unless d.can_receive?
      #  return {return: 0, content: DeliveryMessage::ReceiveFailed}
      #end

      #*own implementation of receive
      if (r = DeliveryService.receive(d,current_user)).result
        {result: 1, content: DeliveryPresenter.new(d).to_json}
      else
        {result: 0, content: r.content}
      end
    end

    # received deliveries
    # get all received deliveries by time and location
    # @deprecated
    # *use get_by_time_and_state api*
    get :received do
      args={
          state: [MovableState::ARRIVED,MovableState::CHECKED,MovableState::REJECTED],
          created_at: params[:receive_date]
      }
      args[:des_location_id]= current_user.location_id
      {result: 1, content: DeliveryPresenter.init_json_presenters(DeliveryService.get_list(args).all)}
    end

    #**
    #@deprecated
    #**
    # confirm_receive
    # end the process of logistics
    # 统一状态之后，原来的状态不能使用了，目前通过confirm_receive接口来统一设置状态
    # 目前这个接口不做任何事情
    # -->2014-11-19需要重新修改
    # -->2014-11-23：运单下的拖清单被接收了，运单本身的状态如何处理？如果这个运单并没有被调用接收？
    post :confirm_receive do
      unless d = LogisticsContainer.exists?(params[:id])
        return {result: 0, content: DeliveryMessage::NotExit}
      end

      unless (m = DeliveryService.confirm_receive(d,current_user)).result
        return {result:0,content: DeliveryMessage::ReceiveFailed}
      end

      return {result:1,content: DeliveryMessage::ReceiveSuccess}

      #if LogisticsContainerService.end_receive(d, current_user)
      #{result: 1, content: DeliveryMessage::ReceiveSuccess}
      #else

      # {result: 0, content: DeliveryMessage::ReceiveFailed}
      #end
    end

    # list
    # @deprecated!
    # @params: delivery_date
    # *get all deliveries sent from current_user's location*
    get :list do
      created_at = Time.parse(params[:delivery_date])
      args = {
          created_at: (created_at.beginning_of_day..created_at.end_of_day),
          source_location_id: current_user.location_id
      }

      args[:user_id] = current_user.id if params[:all].nil?

      {result: 1, content: DeliveryPresenter.init_json_presenters(DeliveryService.get_list(args).all)}
    end
  end
end
