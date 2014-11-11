module CZ
  module Movable
    #include this module to your Model,make sure you have column below
    # :current_location_id,:destination_id,:sender_id,:receiver_id,:delivery_date,:received_date,:state

    def dispatch(destination_id, sender_id = nil)
      state_switch_to(MovableState::WAY)

      self.destination_id = destination_id

      if sender_id
        self.sender_id = sender_id
      end

      self.delivery_date = Time.now

      #self.movable_records.create({destination_id: self.destination_id, state: self.state, action: __method__.to_s})
    end

    def receive(receiver_id = nil)
      state_switch_to(MovableState::ARRIVED)
      self.current_location_id = self.destination_id
      if receiver_id
        self.receiver_id = receiver_id
      end
      self.received_date = Time.now

      #self.movable_records.create({destination_id: self.destination_id, state: self.state, action: __method__.to_s})
    end

    def check(checker_id = nil)
      state_switch_to(MovableState::CHECKED)

    end

    def reject(reject_id = nil)
      state_switch_to(MovableState::REJECTED)

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