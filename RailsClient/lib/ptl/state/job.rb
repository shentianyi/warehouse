module Ptl
  module State
    class Job
      UN_HANDLE=100
      SEND_SUCCESS=200
      SEND_FAIL=201
      HANDLING=201
      HANDLE_SUCCESS=300
      HANDLE_FAIL=400
      INVALID=500


      def self.execute_states
        [UN_HANDLE,SEND_FAIL,SEND_SUCCESS,HANDLE_FAIL]
      end

      def self.display(state)
        case state
          when UN_HANDLE
            '未处理'
          when SEND_SUCCESS
            '发送成功'
          when SEND_FAIL
            '发送失败'
          when HANDLING
            '处理中'
          when HANDLE_SUCCESS
            '处理成功'
          when HANDLE_FAIL
            '处理失败'
          when INVALID
            '错误任务'
          else
            '未知'
        end
      end
    end
  end
end
