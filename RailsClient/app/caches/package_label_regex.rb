class PackageLabelRegex
  @@regex_type=RegexType::PACKAGE_LABEL

  class << self
    def initialize_methods
      Regex.where(type: @@regex_type).all.each do |regex|
        regex.attributes.except('id','code','type','is_sys_default','is_delete','is_dirty','is_new','created_at','updated_at','remark').keys.each do |m|
          self.class.instance_eval do
            define_method("#{regex.code.downcase}_#{m}") { regex.send(m) }
          end
         end
        end
     end
  end
end