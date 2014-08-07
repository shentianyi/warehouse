module Import
  module PositionCsv
    def self.included(base)
      base.extend ClassMethods
      base.extend CsvBase
      base.init_csv_cols
    end
  end

  module ClassMethods
    #@@csv_cols=nil

    def uniq_key
      %w(detail)
    end

    def csv_headers
      class_variable_get(:@@csv_cols).collect { |col| col.header }
    end

    def position_down_block
      Proc.new { |line, item|
        line<<item.detail
        line<<item.whouse_id
      }
    end

    def init_csv_cols
      csv_cols=[]
      csv_cols<< Csv::CsvCol.new(field: 'detail', header: 'Position')
      csv_cols<< Csv::CsvCol.new(field: 'whouse_id', header: 'Ware House',if_foreign: true,foreign: 'Whouse')
      csv_cols<< Csv::CsvCol.new(field: $UPMARKER, header: $UPMARKER)
      class_variable_set(:@@csv_cols,csv_cols)
    end

    def csv_cols
      class_variable_get(:@@csv_cols)
    end
  end
end