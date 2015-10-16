module Ptl
  class Job

    #
    # node_id 是4位数字字符串
    # server_id 是3位数字字符串
    # TCP
    # server_url 是控制器的IP+PORT,比如192.168.0.1:9000
    #
    attr_accessor :type, :id, :node_id, :ptl_job, :curr_state, :to_state, :curr_rate, :to_rate, :curr_display, :to_display, :urgent_size, :size, :server_id, :server_url, :in_time, :node #, :http_type

    DEFAULT_HTTP_TYPE='POST'
    DEFAULT_RETRY_TIMES=3
    DEFAULT_PROCESS_SIZE=10
    DEFAULT_IN_TIME=false

    INT_FIELD=[:curr_state, :to_state, :urgent_size, :size]

    def initialize(options={}, id=nil)
      self.id=id
      puts "4. start init job :#{options}"
      raise 'params is blank' if options.blank?

      self.size=1
      self.in_time=DEFAULT_IN_TIME

      options.each do |k, v|
        self.instance_variable_set("@#{k}", v)
      end

      INT_FIELD.each do |f|
        if v=self.send(f)
          self.send "#{f}=", v.to_i
        end
      end

      node=Node.find(self.to_state)
      node.id=self.node_id
      node.job_id=self.id
      puts "init job : node:#{node.id}"
      # node.job=self
      self.node=node
    end

    def in_queue
      # begin
      params={}
      self.instance_variable_names.each do |name|
        params[name.sub(/@/, '').to_sym]=self.instance_variable_get(name)
      end
      puts "5. create job in database..."
      puts "5.params:#{params}"
      ptl_job=PtlJob.new(
          params: params.to_json,
          node_id: self.node_id,
          to_state: self.to_state,
          to_display:get_to_display
      )
      if ptl_job.to_display=='0000'
        ptl_job.to_state=Ptl::Node::NORMAL
      end
      ptl_job.save
      
      self.id= ptl_job.id
      self.ptl_job=ptl_job

      if in_time
        ptl_job.update_attributes(state: Ptl::State::Job::HANDLING)
        process
      end

      # rescue => e
      #   puts "5 in_queue:error:[#{Time.now}]#{e.message}"
      #   return false
      # end
      true
    end

    def get_to_display
      displays=Node.parse_display(self.curr_display)
      case self.to_state
        when Ptl::Node::NORMAL
          self.node.set_display(0, 0)
        when Node::URGENT_ORDERED
          self.node.set_display(displays[0]+self.urgent_size, displays[1]+self.urgent_size+self.size)
        when Ptl::Node::ORDERED
            self.node.set_display(displays[0], displays[1]+self.size)
        when Node::PICKED
          # 'just change color and rate'
          self.node.set_display(displays[0], displays[1])
        when Node::DELIVERED
          # 'just change color and rate'
          self.node.set_display(displays[0], displays[1])
        when Node::RECEIVED
          self.node.set_display(displays[0]-self.size, displays[1]-self.size)
        else
          raise 'invalid job to state'
      end
      return self.node.display
    end

    def self.out_queue(size=DEFAULT_PROCESS_SIZE)
      PtlJob.where(state: Ptl::State::Job.execute_states)
          .order(:created_at).limit(size).each do |ptl_job|
        puts "[#{Time.now}] execute job from mysql #{ptl_job.id}"
        if job=parse_json_to_job(ptl_job)
          puts "* #{job.id}"
          job.id=ptl_job.id
          job.ptl_job=ptl_job
          job.process
        end
      end
    end

    def self.find_by_ptl_job(ptl_job)
      parse_json_to_job(ptl_job)
    end

    def process
      puts "6. start job process......."
      PhaseMachine.new(self).process
    end


    def job_id_format
      self.id
    end

    private
    def self.parse_json_to_job(ptl_job)
      begin
        params=JSON.parse(ptl_job.params).deep_symbolize_keys
        self.new(params)
      rescue => e
        ptl_job.update_attributes(state: Ptl::State::Job::INVALID, msg: e.message)
        nil
      end
    end
  end
end
