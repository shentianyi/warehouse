module CZ
#发运模块的统一接口
#所有函数只做最基本的发运逻辑和状态验证
  module Movable
    #include this module to your Model,make sure you have column below
    #:current_posotionable_id,:current_positionable_type,:destinationable_id,:destinationable_type,:state
    DISPATCH = "dispatch"
    RECEIVE = "receive"
    CHECK = "check"
    REJECT = "reject"

    @@actions = {
        DISPATCH => MovableState::WAY,
        RECEIVE => MovableState::ARRIVED,
        CHECK => MovableState::CHECKED,
        REJECT => MovableState::REJECTED
    }

    #要加入一个can_dispatch？的方法

    def method_missing(method_name, *args, &block)
      if /^get_[a-z]*_time$/.match(method_name)
        name = method_name.to_s.split("_")[1]
        if @@actions.keys.include? name
          r = get_record(name)
          return  (r.nil? ? self.created_at: r.impl_time).localtime.strftime("%Y-%m-%d %H:%M:%S")
        end
      end

      if /^get_[a-z]*_record$/.match(method_name)
        name = method_name.to_s.split("_")[1]
        if @@actions.keys.include? name
          return get_record(name)
        end
      end
      super(method_name, args, block)
    end

    def dispatch(destination, sender_id)
      if state_switch_to(MovableState::WAY)
        self.update({state:MovableState::WAY,is_dirty:true})
        #self.destinationable = destination
        Record.update_or_create(self, {'id' => sender_id, 'type' => ImplUserType::SENDER, 'action' => __method__.to_s},destination)
        true
      else
        false
      end
    end

    def get_movable_service
      case self.container.type
        when ContainerType::PACKAGE
          return PMovableService
        when ContainerType::FORKLIFT
          return FMovableService
        when ContainerType::DELIVERY
          return DMovableService
      end
    end

    def receive(receiver_id)
      if state_switch_to(MovableState::ARRIVED)
        #self.current_positionable = self.destinationable
        self.update({state:MovableState::ARRIVED,is_dirty:true})
        Record.update_or_create(self, {'id' => receiver_id, 'type' => ImplUserType::RECEIVER, 'action' => __method__.to_s})
        true
      else
        false
      end
    end

    def check(examiner_id)
      if state_switch_to(MovableState::CHECKED)
        self.update({state:MovableState::CHECKED,is_dirty:true})
        Record.update_or_create(self, {'id' => examiner_id, 'type' => ImplUserType::EXAMINER, 'action' => __method__.to_s})
        true
      else
        false
      end
    end

    def reject(rejector_id)
      if state_switch_to(MovableState::REJECTED)
        self.update({state:MovableState::REJECTED,is_dirty:true})
        Record.update_or_create(self, {'id' => rejector_id, 'type' => ImplUserType::REJECTOR, 'action' => __method__.to_s})
        true
      else
        false
      end
    end

    def create_info
      "#{self.created_at.localtime.strftime('%Y-%m-%d %H:%M:%S')} #{self.user.name}[#{self.user_id}] 创建于 #{self.source.name}"
    end

    def get_record(action)
      Record.where({impl_action: action,recordable:self}).first
    end

    #for CZ::State
    def base_state
      MovableState.base(self.state)
    end

    def state_switch_to state
      if MovableState.before(state).include? self.get_state
        #self.state = state
        true
      else
        false
      end
    end

    def get_state
      self.state
    end

    def state_for(action)
      check_action_state(action,get_state)
    end

    def check_action_state(action,state)
      MovableState.before(get_state_by_action(action)).include? state
    end

    def get_state_by_action(action)
      return @@actions[action]
    end

    def state_display
      MovableState.display(self.state)
    end

    def source
      l = Location.find_by_id(self.source_location_id)
      l.nil? ? Location.new : l
    end

    def destination
      l = Location.find_by_id(self.des_location_id)
      l.nil? ? Location.new : l
    end
  end
end