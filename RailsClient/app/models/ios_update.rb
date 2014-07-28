#encoding: utf-8
require "base_class"

class IosUpdate<CZ::BaseClass
  attr_accessor :app_version, :is_force_update

  def self.find
    cache=self.new({app_version:SysConfigCache.ios_version_value,is_force_update:SysConfigCache.is_force_value})
    return cache
  end

  def old_version? version
    (version||default_version)<self.app_version ? 1 : 0
  end

  def is_force_update?
    self.is_force_update=='1' ? 1:0
  end

  def self.key
    'whousedb::ios::version'
  end

  def save
    #$redis.hmset Setting.key , 'app_version', self.app_version, 'is_force_update', self.is_force_update
  end

  def default_version
    '0.1'
  end
end