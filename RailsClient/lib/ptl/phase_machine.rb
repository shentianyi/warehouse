require 'rest-client'

module Ptl
  class PhaseMachine
    attr_accessor :led_id, :led_curr_state, :server, :http_type

    REQUIRED_PARAMS=[:led_id, :led_curr_state, :server]
    DEFAULT_HTTP_TYPE='POST'
    DEFAULT_RETRY_TIMES=3


    def initialize(options={})
      raise 'params is blank' if options.blank?
      REQUIRED_PARAMS.each { |k| self.instance_variable_set("@#{k}", options[k]) if options.has_key?(k) }
    end

    def enqueue

    end
  end
end