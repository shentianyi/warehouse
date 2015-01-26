module Extensions
  module STATE
    extend ActiveSupport::Concern
    included do
      after_save :log_state

      def log_state
        if self.state_changed?
          self.state_logs.create(state_before: self.state_was, state_after: self.state)
        end
      end

      def set_state state
        if Kernel.const_get(self.class.name+"State").can_change? self.state,state
          self.update(state:state)
          true
        else
          false
        end
      end


      def can_reset_sync_dirty_flag
        new_item=self.class.unscoped.find_by_id(self.id)
        self.attributes.except('uuid','id','created_at','updated_at','is_dirty','is_new','is_delete').keys.each do |attr|
          return false if self.send(attr.to_sym)!=new_item.send(attr.to_sym)
        end
        return true
      end

    end
  end
end