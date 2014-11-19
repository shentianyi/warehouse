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

    def method_missing(method_name,*args,&block)

      super(method_name,args,block)
    end

    def can?(action)
      case action
        when @@action[:delete]
        when @@action[:copy]
        when @@action[:update]
          if self.base_state == LOCK
            return false
          else
            return true
          end
      end
      false
    end
  end
end
