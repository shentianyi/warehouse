Ancestry.module_eval do
  remove_const(:ANCESTRY_PATTERN) if defined?(:ANCESTRY_PATTERN)
  const_set :ANCESTRY_PATTERN, /\A\w+(-?\w+)*/
end

Ancestry::InstanceMethods.module_eval do
  def ancestor_str
    read_attribute(self.ancestry_base_class.ancestry_column)
  end

  def ancestry= ancestry
    write_attribute(self.ancestry_base_class.ancestry_column, ancestry)
  end
end
