$default_db=0
$redis=Redis::Namespace.new('WarehouseRedisStore', redis: Redis.new(:host => '127.0.0.1', :port => '6379'))

if defined?(PhusionPassenger)
  PhusionPassenger.on_event(:starting_worker_process) do |forked|
    if forked
      $redis.client.reconnect
      Rails.cache.reconnect
    end
  end
end