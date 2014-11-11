module CZ
  #发运模块的统一接口
  #所有函数只做最基本的发运逻辑和状态验证
  module Movable
    #include this module to your Model,make sure you have column below
    # :current_location_id,:destination_id,:sender_id,:receiver_id,:delivery_date,:received_date,:state

    def dispatch(destination_id, sender_id)
      if state_switch_to(MovableState::WAY)

        self.destination_id = destination_id
        self.sender_id = sender_id
        self.delivery_date = Time.now
      end
      #self.movable_records.create({destination_id: self.destination_id, state: self.state, action: __method__.to_s})
    end

    def receive(receiver_id)
      if state_switch_to(MovableState::ARRIVED)
        self.current_location_id = self.destination_id
        self.receiver_id = receiver_id
        self.received_date = Time.now
      end
    end

    def check(examiner_id)
      if state_switch_to(MovableState::CHECKED)
      end
    end

    def reject(rejector_id)
      if state_switch_to(MovableState::REJECTED)
      end
    end

    #for CZ::State
    def base_state
      MovableState.base(self.state)
    end

    def state_switch_to state
      if MovableState.before(state).include? self.get_state
        self.state = state
        true
      else
        false
      end
    end

    def get_state
      self.state
    end
  end
end