class PackageLabelRegex
  @@regex_type=RegexType::PACKAGE_LABEL

  class << self
    self.class.class_eval do
      Regex.where(type: @@regex_type).all.each do |regex|
        regex.attribute_names.each do |m|
          define_method("#{regex.code.downcase}_#{m}") { regex.send(m) }
        end
      end
    end
  end

  #def self.all
  #  key=generate_cache_key
  #  initialize_cache unless Rails.cache.exist?(key)
  #  Rails.cache.read key
  #end
  #
  #def self.initialize_cache
  #  Rails.cache.write generate_cache_key, Regex.where(type: @@regex_type).all
  #  create_class_method
  #end
  #
  #def self.generate_cache_key
  #  "regex_cache:#{@@regex_type}:"
  #end

end