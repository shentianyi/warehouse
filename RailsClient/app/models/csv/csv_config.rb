require 'base_class'
module Csv
  class CsvConfig<CZ::BaseClass
    attr_accessor :encoding, :col_sep, :file_path
  end
end
