class SysConfig < ActiveRecord::Base
  include Extensions::UUID

  after_update :re_init_methods

  def re_init_methods
    SysConfigCache.initialize_methods
  end
end