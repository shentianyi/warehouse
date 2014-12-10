class TransContainerWorker
  include Sidekiq::Worker

  sidekiq_options :queue => :transcontainersjob, :retry => false,:backtrace => true

  def perform(ids)
    DeliveriesHelper.transfer_old_deliveries(ids)
  end
end