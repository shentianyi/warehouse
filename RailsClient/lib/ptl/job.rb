require 'ptl/node'

module Ptl
  class Job

    #
    # node_id 是4位数字字符串
    # server_id 是3位数字字符串
    # TCP
    # server_url 是控制器的IP+PORT,比如192.168.0.1:9000
    #
    attr_accessor :id, :node_id, :curr_state, :to_state, :curr_rate, :to_rate, :curr_display, :to_display, :size, :server_id, :server_url, :in_time, :node #, :http_type

    DEFAULT_HTTP_TYPE='POST'
    DEFAULT_RETRY_TIMES=3
    DEFAULT_PROCESS_SIZE=10
    DEFAULT_IN_TIME=false

    INT_FIELD=[:curr_state, :to_state, :size]

    def initialize(options={})

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
      self.node=node
    end

    def in_queue
      begin
        params={}
        self.instance_variable_names.each do |name|
          params[name.sub(/@/, '').to_sym]=self.instance_variable_get(name)
        end
        puts "5. create job in database..."
        j=PtlJob.create(
            params: params.to_json
        )
        self.id= j.id

        if in_time
          j.update_attributes(state:Ptl::State::Job::HANDLING)
          process
        end

      rescue
        return false
      end
      true
    end

    def self.out_queue(size=DEFAULT_PROCESS_SIZE)
      PtlJob.where(state: Ptl::State::Job.execute_states).order(:created_at).limit(size).each do |ptl_job|
        puts "[#{Time.now}] execute job from mysql #{ptl_job.id}"
        job=parse_json_to_job(ptl_job.params)
        job.process
      end
    end

    def self.find_by_ptl_job(ptl_job)
      parse_json_to_job(ptl_job.params)
    end

    def process
      puts "6. start job process......."
      PhaseMachine.new(self).process
    end

    private
    def self.parse_json_to_job(json)
      params=JSON.parse(json).deep_symbolize_keys
      self.new(params)
    end
  end
end