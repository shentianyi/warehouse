module Ptl
  class Job
    attr_accessor :id, :led_id, :curr_state, :to_state, :curr_display, :size, :server #, :http_type

    DEFAULT_HTTP_TYPE='POST'
    DEFAULT_RETRY_TIMES=3
    DEFAULT_PROCESS_SIZE=50

    def initialize(options={})
      self.size=1
      raise 'params is blank' if options.blank?
      options.each do |k, v|
        self.instance_variable_set("@#{k}", v)
      end
    end

    def enqueue
      begin
        params={}
        self.instance_variable_names.each do |name|
          params[name.sub(/@/, '').to_sym]=self.instance_variable_get(name)
        end
        PtlJob.create(
            params: params.to_json
        )
      rescue
        return false
      end
      true
    end

    # def self.to_process(size=DEFAULT_PROCESS_SIZE)
    #   PtlJob.where.not(state: State::Job::UN_HANDLE).order(:created).limit(size)
    # end
    #

    def self.process
      if job= PtlJob.where.not(state: State::Job::UN_HANDLE).order(:created).first
        JSON.parse(PtlJob.first.params).deep_symbolize_keys!
      end
    end
  end
end