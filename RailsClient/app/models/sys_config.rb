class SysConfig < ActiveRecord::Base
  include Extensions::UUID

  after_update :re_init_methods

  def re_init_methods
    SysConfigCache.initialize_methods
  end

  def self.is_boolen? id
    config = SysConfig.find_by(id: id)
    if !config.blank? && ['true', 'false'].include?(config.value)
      true
    else
      false
    end
  end
end