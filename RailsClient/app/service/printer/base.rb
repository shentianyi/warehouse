module Printer
  class Base
    attr_accessor :id, :data_set, :target_ids, :head, :body, :foot, :code

    def initialize(id=nil, code=nil)
      if code.blank?
        self.code=self.class.name
      end
      self.data_set =[]
      self.id=id
      generate_data
    end
  end
end