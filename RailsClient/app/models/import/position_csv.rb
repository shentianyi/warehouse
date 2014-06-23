module Import
  module PositionCsv
    def self.included(base)
      base.extend ClassMethods
      base.extend CsvBase
      base.init_csv_cols
    end
  end

  module ClassMethods
    @@csv_cols=nil

    def uniq_key
      %w(id)
    end

    def csv_headers
      @@csv_cols.collect { |col| col.header }
    end

    def down_block
      Proc.new { |line, item|
        line<<item.id
        line<<item.detail
        line<<item.whouse_id
      }
    end

    def init_csv_cols
      @@csv_cols=[]
      @@csv_cols<< Csv::CsvCol.new(field: 'id', header: 'Position Nr')
      @@csv_cols<< Csv::CsvCol.new(field: 'detail', header: 'Position')
      @@csv_cols<< Csv::CsvCol.new(field: 'whouse_id', header: 'Ware House',if_foreign: true,foreign: 'Whouse')


      @@csv_cols<< Csv::CsvCol.new(field: $UPMARKER, header: $UPMARKER)
    end

    def csv_cols
      @@csv_cols
    end
  end
end