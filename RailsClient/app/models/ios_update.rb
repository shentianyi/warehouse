#encoding: utf-8
require "base_class"

class IosUpdate<CZ::BaseClass
  attr_accessor :app_version, :is_force_update

  def self.find
    if $redis.exists(key)
      cache=self.new($redis.hgetall key)
      return cache
    end
  end

  def old_version? version
    (version||default_version)<self.app_version ? 1 : 0
  end

  def is_force_update?
    self.is_force_update ? 1:0
  end

  def self.key
    'whousedb::ios::version'
  end

  def save
    $redis.hmset Setting.key , 'app_version', self.app_version, 'is_force_update', self.is_force_update
  end

  def default_version
    '0.1'
  end
end