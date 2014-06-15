module Printer
  class P001<Base
    Head=[:id,:whouse,:delivery_date,:user]
    Body=[:package_id,:part_id,:quantity,:w_date,:receive_position]
    def initialize(id=nil)
      #self.data_set=[]
      #for i in 0...10
      #  data=[]
      #  [:Body, :Head].each { |key|
      #    data<<{Key: key, Value: 'Value'+i.to_s}
      #  }
      #  self.data_set<<data
      #end

    end

    def generate_head

    end
  end
end