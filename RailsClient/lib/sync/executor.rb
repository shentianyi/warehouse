module Sync
  class Executor <CZ::BaseClass
    attr_accessor :key, :name, :get, :post, :put, :delete

    def self.all
      Sync::Config.executors.values
    end

    def self.find(key)
      Sync::Config.executors[key]
    end

    def update(arg={})
      self.get=arg[:get]
      self.post=arg[:post]
      self.put=arg[:put]
      self.delete=arg[:delete]
      Sync::Config.executor=self
    end
  end
end