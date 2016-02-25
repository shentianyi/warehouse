module Import
  module PartTypeCsv
    def self.included(base)
      base.extend ClassMethods
      base.extend CsvBase
      base.init_csv_cols
      base.init_uniq_key
    end
  end

  module ClassMethods
    def uniq_key
      class_variable_get(:@@ukeys)
    end

    def csv_headers
      class_variable_get(:@@csv_cols).collect { |col| col.header }
    end

    def part_type_down_block
      Proc.new { |line, item|
        line<<item.id
        line<<item.name
      }
    end

    def init_csv_cols
      csv_cols=[]
      csv_cols<< Csv::CsvCol.new(field: 'nr', header: 'Nr')
      csv_cols<< Csv::CsvCol.new(field: 'name', header: 'Name')
      csv_cols<< Csv::CsvCol.new(field: $UPMARKER, header: $UPMARKER)
      class_variable_set(:@@csv_cols, csv_cols)
    end

    def csv_cols
      class_variable_get(:@@csv_cols)
    end

    def init_uniq_key
      class_variable_set(:@@ukeys,%w(nr))
    end
  end
end