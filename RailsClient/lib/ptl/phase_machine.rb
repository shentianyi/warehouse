require 'rest-client'
require 'ptl/node'
module Ptl
  class PhaseMachine
    attr_accessor :job

    def initialize(job)
      self.job=job
    end

    def process
      begin
        node=job.node
        displays=Node.parse_display(job.curr_display)

        log.info("start process job:#{job.id}")
        case job.to_state
          when Ptl::Node::NORMAL
            # all curr states apply this method
            node.set_display(0, 0)
          when Ptl::Node::ORDERED
            # TODO
            # call create order items api
            # params led
            #
            result=true # api
            if result
              node.set_display(displays[0], displays[1]+job.size)
            end
          when Node::URGENT_ORDERED
            # TODO
            # call create order items api
            # params led
            #
            result=true # api
            if result
              node.set_display(displays[0]+job.size, displays[1]+job.size)
            end
          when Node::PICKED
            # 'just change color and rate'
          when Node::DELIVERED
            # 'just change color and rate'
          when Node::RECEIVED
            node.set_display(displays[0]-job.size, displays[1]-job.size)
          else
            raise 'invalid job to state'
        end
        node.job=self.job
        self.job.node=node
        Ptl::Message::SendParser.new(job).process
      rescue => e
        log.error(e.message)
      end
    end

  end
end
