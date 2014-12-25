module Printer
  class Base
    attr_accessor :id,:data_set,:target_ids, :head, :body, :foot
    def initialize(id=nil,target_ids=nil)
      self.data_set =[]
      self.id=id
      self.target_ids=target_ids
      generate_data
    end
  end
end