require 'socket'
module Ptl
  class Server

    attr_accessor :server, :clients

    def self.run
      job_t=Thread.new { execute_job }
      job_t.join
    end

    def self.execute_job
      puts "[#{Time.now}]-- start execute mysql job"
      loop {
        # Thread.start do
        sleep(1)
        puts "[#{Time.now}]-- executing mysql job"
        Ptl::Job.out_queue
        # end
      }
    end
  end
end