module Printer
  class P001<Base
    def initialize(id=nil)
      self.data_set=[]
      for i in 0...10
        data=[]
        [:Body, :Head].each { |key|
          data<<{Key: key, Value: 'Value'+i.to_s}
        }
        self.data_set<<data
      end
    end
  end
end