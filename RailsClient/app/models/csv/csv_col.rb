require 'base_class'
module Csv
  class CsvCol<CZ::BaseClass
    attr_accessor :field, :header, :null, :is_foreign, :foreign

    def default
      {is_foreign: false, null: false}
    end
  end
end