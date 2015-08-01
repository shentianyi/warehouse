class PtlJobWorker
  include Sidekiq::Worker
  sidekiq_options(queue: :ptl)

  def perform
    loop_count=0
    loop {
      break if loop_count>20
      Ptl::Job.out_queue
      puts "[#{Time.now}] start ptl job loop......"
      sleep(2)
      loop_count+=1
    }
  end
end
