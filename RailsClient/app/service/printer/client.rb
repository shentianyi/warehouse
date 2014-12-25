module Printer
  class Client
    attr_accessor :printer
    # code if printer uuid, and the class file name
    def initialize(code,id,targets)
      self.printer= Kernel.const_get("Printer::#{code.downcase.classify}").new(id,targets)
    end

    def gen_data
      self.printer.data_set
    end
  end
end