sidekqi_redis_conn =proc {
  Redis::Namespace.new("whouse_sidekiqworker", :redis => $redis)
}
#

Sidekiq.configure_server do |config|
  if (database_url = ENV['DATABASE_URL'])
    pool_size = Sidekiq.options[:concurrency] + 2
    ENV['DATABASE_URL'] = "#{database_url}?pool=#{pool_size}"
    ActiveRecord::Base.establish_connection
  end
  config.redis = ConnectionPool.new(size: 25, &sidekqi_redis_conn)
end

#
Sidekiq.configure_client do |config|
  config.redis = ConnectionPool.new(size: 5, &sidekqi_redis_conn)
end
