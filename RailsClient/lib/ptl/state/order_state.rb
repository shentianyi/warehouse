module Ptl
  module State
    class OrderState
      UN_HANDLE=100
      SUCCESS=200
      FAIL=300


      def self.execute_states
        [UN_HANDLE,FAIL]
      end

      def self.do_order?(state)
        execute_states.include?(state)
      end

      def self.display(state)
        case state
          when UN_HANDLE
            '未处理'
          when SUCCESS
            '要货成功'
          when FAIL
            '要货失败'
          else
            '未知'
        end
      end
    end
  end
end
