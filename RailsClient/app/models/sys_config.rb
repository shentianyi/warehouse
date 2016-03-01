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


  def self.jiaxuan_extra_location_update config
    data=[]

    config.each do |lc|
      sc=SysConfig.find_by_code(lc.last[:location_code])
      l=Location.find_by_id(lc.last[:location_id])
      if sc && l
        p sc
        p l
        sc.update_attributes(value: l.nr)
      end

      data<<sc
    end

    data
  end

  def self.jiaxuan_extra_custom_update config
    data=[]

    config.each do |cc|
      sc=SysConfig.find_by_code(cc.last[:custom_code])
      t=Tenant.find_by_id(cc.last[:location_id])
      if sc && t
        p sc
        p t
        sc.update_attributes(value: t.code)
      end
      data<<sc
    end

    data
  end
end