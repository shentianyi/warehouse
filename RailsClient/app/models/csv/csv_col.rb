require 'base_class'
module Csv
  class CsvCol<CZ::BaseClass
    attr_accessor :field, :header, :null, :is_foreign, :foreign, :foreign_field

    def default
      {is_foreign: false, null: false, foreign_field: 'id'}
    end
  end
end