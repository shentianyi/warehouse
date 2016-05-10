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

  def self.import_whouse_info
    whouse=Whouse.find_by_id(SysConfigCache.default_import_whouse_value)
    position=Position.find_by_detail(SysConfigCache.default_import_position_value)
    if whouse && position
      {
          whouse_id: whouse.id,
          position: position.detail
      }
    else
      {
          error: '请配置默认入库信息'
      }
    end
  end
end