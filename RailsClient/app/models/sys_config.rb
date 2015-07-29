class SysConfig < ActiveRecord::Base
  include Extensions::UUID

  after_update :re_init_methods


  def self.method_missing(method_name, *args, &block)
    puts "-------sysconfig method messing: #{method_name}---------"
    if setting=SysConfig.where(code: method_name.upcase).first
      return setting.value
    else
      super
    end
  end

  def re_init_methods
    SysConfigCache.initialize_methods
  end
end