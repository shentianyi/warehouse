class SysConfigCache

  class << self
    def initialize_methods
      SysConfig.all.each do |config|
        config.attributes.except('id','code','is_delete','is_dirty','is_new','created_at','updated_at').keys.each do |m|
          self.class.instance_eval do
            define_method("#{config.code.underscore}_#{m}") { config.send(m) }
          end
         end
        end
     end
  end
end