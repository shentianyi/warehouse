module Ptl
	module Type
		class ConfirmMsgType
			HANDLE_SUCCESS=0
			SEND_SUCCESS=1
			SEND_FAIL=2
			MSG_CHECK_FAIL=3
			PHASE_TRANS_BROKE=4
			NODE_TRANS_BROKE=5
			OTHER_ERROR=6


			def self.msg(type)
			 case type
			 when HANDLE_SUCCESS
				 '处理成功'
			 when SEND_SUCCESS
				 '发送节点成功'
			 when SEND_FAIL
				 '发送节点失败'
			 when MSG_CHECK_FAIL
				 '报文校验失败'
			 when PHASE_TRANS_BROKE
				 '上位机传输中断'
			 when NODE_TRANS_BROKE
				 '节点阶段传输中断'
			 when OTHER_ERROR
				 '其他错误'
			 else
				 'invalid msg type'
			 end
			end
		end
	end
end
