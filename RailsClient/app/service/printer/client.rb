module Printer
  class Client
    attr_accessor :printer
    # code if printer uuid, and the class file name
    def initialize(code, id)
      self.printer= Kernel.const_get("Printer::#{code.downcase.classify}").new(id,code)
    end

    def gen_data
      {
          code: self.printer.code,
          data_set: self.printer.data_set
      }
    end
  end
end