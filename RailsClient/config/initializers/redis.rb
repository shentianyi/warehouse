=begin
require 'redis'
require 'redis-namespace'

$default_db = 11

$redis=Redis::Namespace.new('WarehouseRedisStore', redis: Redis.new(:host => '127.0.0.1', :port => '6379'))

if defined?(PhusionPassenger)
  PhusionPassenger.on_event(:starting_worker_process) do |forked|
    if forked
      $redis.client.disconnect
      Rails.cache.disconnect if Rails.cache.respond_to? :disconnect
      $redis=Redis::Namespace.new('WarehouseRedisStore',
                                  redis: Redis.new(:host => '127.0.0.1', :port => '6379'))
      Rails.cache.redis=$redis
      Rails.cache.reconnect if Rails.cache.respond_to? :reconnect
      $redis.client.reconnect
    end
  end
end
=end
