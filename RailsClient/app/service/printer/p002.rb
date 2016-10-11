# print delivery
module Printer
  class P002<Base
    def generate_data

      d=LogisticsContainer.find(self.id)

      if d.source_location.nr=='HEMLO'
        self.code='P0020'
        self.data_set= Printer::P0020.new(self.id, 'P0020').data_set
      elsif d.source_location.nr=='SHJXLO'
        self.code='P0021'
        self.data_set= Printer::P0021.new(self.id, 'P0021').data_set
      end
    end
  end
end
