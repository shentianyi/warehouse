module Ptl
  module State
    class Job
      UN_HANDLE=100
      SEND_SUCCESS=200
      HANDLING=201
      HANDLE_SUCCESS=300
      HANDLE_FAIL=400

      def self.execute_states
        [UN_HANDLE,SEND_SUCCESS,HANDLE_FAIL]
      end
    end
  end
end
