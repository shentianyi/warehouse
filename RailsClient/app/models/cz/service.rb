module CZ
  module Service
    def method_missing(method_name, *args, &block)
      if /^get_[a-z]*_service$/.match(method_name)
        name = method_name.to_s.split("_")[1]
        return "#{name.capitalize}Service".constantize
      end

      if /^get_[a-z]*_presenter$/.match(method_name)
        name = method_name.to_s.split("_")[1]
        return "#{name.capitalize}Presenter".constantize
      end
      super(method_name, args, block)
    end
  end
end