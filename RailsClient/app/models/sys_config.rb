class SysConfig < ActiveRecord::Base
  include Extensions::UUID

  after_save :re_init_methods


  def self.method_missing(method_name, *args, &block)
    puts method_name
    if method_name.match(/\?$/)
      puts '----------------------'
      if setting=SysConfig.where(code: method_name.to_s.sub(/\?$/,'')).first
        return setting.value=='1'
      else
        super
      end
    elsif setting=SysConfig.where(code: method_name).first
      return setting.value
    else
      super
    end
  end

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