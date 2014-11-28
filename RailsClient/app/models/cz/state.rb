#base state
module CZ
  module State
    INIT = 0
    LOCK = 1

    @@action = {
        :delete => 'delete',
        :copy => 'copy',
        :update => 'update'
    }

    def method_missing(method_name, *args, &block)
      if /^can_[a-z]*[?]$/.match(method_name)
        action = method_name.to_s.gsub("?", "").split("_").last
        if @@action.values.include?(action)
          return can? action
        end
      end
      super(method_name, args, block)
    end

    def can?(action)
      case action
        when @@action[:delete], @@action[:copy], @@action[:update]
          if self.base_state == LOCK
            return false
          else
            return true
          end
      end
      return false
    end
  end
end
