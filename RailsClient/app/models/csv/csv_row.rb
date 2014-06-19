require 'base_class'
module Csv
  class CsvRow<CZ::BaseClass
    attr_accessor :field, :header, :is_foreign, :foreign

  end
end