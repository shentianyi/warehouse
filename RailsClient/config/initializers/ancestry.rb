Ancestry::InstanceMethods.module_eval do
  def ancestor_str
    read_attribute(self.ancestry_base_class.ancestry_column)
  end


end
